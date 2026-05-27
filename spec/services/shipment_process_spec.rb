require 'rails_helper'

RSpec.describe ShipmentProcess, type: :service do
  let(:storage) { create(:storage) }
  # Create an item that uses FIFO inventory method
  let(:item)    { create(:item, inventory_method: :fifo) }

  describe '#call' do
    context 'when shipment is processed' do
        let(:shipment) do
          # Shipment with a single shipment_item of qty 8 (items_count is not used for qty)
          create(:shipment, :processed, storage: storage, items_count: 1)
        end

        before do
          # Stub FIFO batch allocation to simulate two batches: older (qty 3) and newer (qty 10)
          allow(InventoryTransaction).to receive(:get_batches_for) do |_item_id, _storage_id, qty, _shipped_at, method: _method|
            # Return an array of batch hashes that sum to the requested qty (8)
            # Older batch first
            [ { qty: 3, cost: 10.0, batch_number: "OLD_BATCH" },
             { qty: 5, cost: 10.0, batch_number: "NEW_BATCH" } ]
          end
        end

      it 'creates an InventoryTransaction for each shipment_item batch' do
          expect { ShipmentProcess.new(shipment).call }
            .to change(InventoryTransaction, :count).by(2)

        shipment_item = shipment.shipment_items.first
          # Two transactions should be created – one for each batch
          transactions = InventoryTransaction.where(operation: shipment).order(:id)
          expect(transactions.size).to eq(2)

          older_tx, newer_tx = transactions

          expect(older_tx.item.id).to eq(shipment_item.item.id)
          expect(older_tx.storage.id).to eq(storage.id)
          expect(older_tx.qty).to eq(-3)
          expect(older_tx.batch_number).to eq('OLD_BATCH')

          expect(newer_tx.item.id).to eq(shipment_item.item.id)
          expect(newer_tx.storage.id).to eq(storage.id)
          expect(newer_tx.qty).to eq(-5)
          expect(newer_tx.batch_number).to eq('NEW_BATCH')

          expect(older_tx.operation.id).to eq(shipment.id)
          expect(newer_tx.operation.id).to eq(shipment.id)
          expect(older_tx.transaction_time).to eq(shipment.shipped_at)
          expect(newer_tx.transaction_time).to eq(shipment.shipped_at)
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

  describe '#call LIFO' do
    let(:lifo_item) { create(:item, method: :lifo) }

    let(:shipment) do
      # Shipment with a single shipment_item of qty 11 for LIFO test
      create(:shipment, :processed, storage: storage, items_count: 1)
    end

    before do
      # Stub LIFO batch allocation: newer batch first, then older batch
      allow(InventoryTransaction).to receive(:get_batches_for) do |_item_id, _storage_id, qty, _shipped_at, method: _method|
        [ { qty: 10, cost: 10.0, batch_number: "NEW_BATCH" },
          { qty: 1, cost: 10.0, batch_number: "OLD_BATCH" } ]
      end
    end

    it 'creates correct LIFO InventoryTransaction records' do
      # Adjust shipment_item to use lifo_item and qty 11
      shipment_item = shipment.shipment_items.first
      shipment_item.update!(item: lifo_item, qty: 11)

      expect { ShipmentProcess.new(shipment).call }
        .to change(InventoryTransaction, :count).by(2)

      transactions = InventoryTransaction.where(operation: shipment).order(:id)
      expect(transactions.size).to eq(2)

      newer_tx, older_tx = transactions

      expect(newer_tx.qty).to eq(-10)
      expect(newer_tx.batch_number).to eq('NEW_BATCH')
      expect(older_tx.qty).to eq(-1)
      expect(older_tx.batch_number).to eq('OLD_BATCH')
    end
  end
end
