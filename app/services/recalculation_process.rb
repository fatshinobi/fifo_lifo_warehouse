class RecalculationProcess
  def self.call(start_time, end_time)
    ActiveRecord::Base.transaction do
      Receiving.where(received_at: start_time..end_time).where(stock_state: :processed).update_all(stock_state: :recalculating)
      Shipment.where(shipped_at: start_time..end_time).where(stock_state: :processed).update_all(stock_state: :recalculating)
      Transfer.where(transferred_at: start_time..end_time).where(stock_state: :processed).update_all(stock_state: :recalculating)
      InventoryTransaction.where(transaction_time: start_time..end_time).delete_all
    end

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
      when Shipment
        ShipmentProcess.new(record).call
      when Transfer
        TransferProcess.new(record).call
      end
    end
  end
end
