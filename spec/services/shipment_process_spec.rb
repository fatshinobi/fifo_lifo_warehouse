require 'rails_helper'

RSpec.describe ShipmentProcess, type: :service do
  let(:storage) { create(:storage) }
  let(:item)    { create(:item) }

  describe '#call' do
    context 'when shipment is processed' do
      let(:shipment) do
        create(:shipment, :processed, storage: storage, items_count: 2)
      end

      before do
        # Stub FIFO batch allocation to return deterministic batches
        allow(InventoryTransaction).to receive(:get_batches_for) do |_item_id, _storage_id, qty, _shipped_at, method: _method|
          Array.new(qty) { |i| { qty: 1, cost: 10.0, batch_number: "BATCH#{i + 1}" } }
        end
      end

      it 'creates an InventoryTransaction for each shipment_item batch' do
        expect { ShipmentProcess.new(shipment).call }
          .to change(InventoryTransaction, :count).by(2)

        shipment_item = shipment.shipment_items.first
        transaction = InventoryTransaction.where(operation: shipment).first

        expect(transaction.item.id).to eq(shipment_item.item.id)
        expect(transaction.storage.id).to eq(storage.id)
        expect(transaction.qty).to eq(-1) # negative because items leave storage
        expect(transaction.cost).to eq(10.0)
        expect(transaction.batch_number).to start_with('BATCH')
        expect(transaction.operation.id).to eq(shipment.id)
        expect(transaction.transaction_time).to eq(shipment.shipped_at)
      end
    end

    context 'when shipment is a draft' do
      let(:shipment) { create(:shipment, :draft, storage: storage, items_count: 1) }

      before do
        # create an existing transaction that should be removed on draft cleanup
        create(:inventory_transaction, operation: shipment)
      end

      it 'removes all inventory transactions linked to the shipment' do
        expect { ShipmentProcess.new(shipment).call }
          .to change(InventoryTransaction, :count).by(-1)
      end
    end
  end
end
