class RecalculationJob < ApplicationJob
  queue_as :default

  def perform(start_time, end_time)
    ActiveRecord::Base.transaction do
      Receiving.where(received_at: start_time..end_time).where(stock_state: :processed).update_all(stock_state: :recalculating)
      Shipment.where(shipped_at: start_time..end_time).where(stock_state: :processed).update_all(stock_state: :recalculating)
      Transfer.where(transferred_at: start_time..end_time).where(stock_state: :processed).update_all(stock_state: :recalculating)
      InventoryTransaction.where(transaction_time: start_time..end_time).delete_all
    end

    # Collect all operation records within the time window and order them chronologically.
    # Convert each ActiveRecord relation to an array, combine them, and sort by the
    # appropriate timestamp attribute for each model type.
    operations_records = (
      Receiving.where(received_at: start_time..end_time).where(stock_state: :recalculating).to_a +
      Shipment.where(shipped_at: start_time..end_time).where(stock_state: :recalculating).to_a +
      Transfer.where(transferred_at: start_time..end_time).where(stock_state: :recalculating).to_a
    ).sort_by do |record|
      case record
      when Receiving
        record.received_at
      when Shipment
        record.shipped_at
      when Transfer
        record.transferred_at
      end
    end

    operations_records.each do |record|
      record.update!(stock_state: :processed)
      case record
      when Receiving
        ReceivingProcess.new(record).call
        record.update!(stock_state: :processed)
      when Shipment
        ShipmentProcess.new(record).call
        record.update!(stock_state: :processed)
      when Transfer
        TransferProcess.new(record).call
        record.update!(stock_state: :processed)
      end
    end

    RecalculationMailer.finished.deliver_later
  end
end
