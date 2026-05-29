require 'rails_helper'

RSpec.describe RecalculationProcess, type: :service do
  let(:storage) { create(:storage) }
  let(:item) { create(:item, method: :fifo) }
  let(:time_now) { Time.current }
  let(:time_later) { time_now + 1.hour }

  describe '.call' do
    context 'when recalculating transactions for modified operations' do
      let!(:inventory_1) do
        create(:receiving, :processed, storage: storage, received_at: time_now, items_count: 1)
      end
      let!(:inventory_item_1) do
        inventory_1.receiving_items.first
      end

      let!(:inventory_2) do
        create(:receiving, :processed, storage: storage, received_at: time_now, items_count: 1)
      end
      let!(:inventory_item_2) do
        inventory_2.receiving_items.first
      end

      let!(:shipment_1) do
        create(:shipment, :processed, storage: storage, shipped_at: time_now, items_count: 1)
      end
      let!(:shipment_item_1) do
        shipment_1.shipment_items.first
      end

      let!(:old_tx_inventory_1) do
        create(:inventory_transaction,
               item: item,
               storage: storage,
               qty: 5,
               cost: 10.0,
               batch_number: 'OLD',
               operation: inventory_1,
               transaction_time: time_now)
      end

      let!(:old_tx_inventory_2) do
        create(:inventory_transaction,
               item: item,
               storage: storage,
               qty: 10,
               cost: 10.0,
               batch_number: 'NEW',
               operation: inventory_2,
               transaction_time: time_now)
      end

      let!(:old_tx_shipment_1_old) do
        create(:inventory_transaction,
               item: item,
               storage: storage,
               qty: -5,
               cost: 10.0,
               batch_number: 'OLD',
               operation: shipment_1,
               transaction_time: time_now)
      end

      let!(:old_tx_shipment_1_new) do
        create(:inventory_transaction,
               item: item,
               storage: storage,
               qty: -3,
               cost: 10.0,
               batch_number: 'NEW',
               operation: shipment_1,
               transaction_time: time_now)
      end

      before do
        inventory_item_1.update!(item: item, qty: 8, cost: 10.0)
        inventory_item_2.update!(item: item, qty: 10, cost: 10.0)
        shipment_item_1.update!(item: item, qty: 8, price: 10.0)

        RecalculationProcess.call(time_now, time_later)
      end

      it 'marks all operations as processed' do
        expect(inventory_1.reload.processed?).to be true
        expect(inventory_2.reload.processed?).to be true
        expect(shipment_1.reload.processed?).to be true
      end

      it 'creates new inventory transactions' do
        expect(InventoryTransaction.where(operation: inventory_1).count).to eq(1)
        expect(InventoryTransaction.where(operation: inventory_2).count).to eq(1)
        expect(InventoryTransaction.where(operation: shipment_1).count).to eq(1)
      end

      it 'deletes old transactions and creates new ones with updated quantities' do
        expect(InventoryTransaction.find_by(id: old_tx_inventory_1.id)).to be_nil
        expect(InventoryTransaction.find_by(id: old_tx_inventory_2.id)).to be_nil
        expect(InventoryTransaction.find_by(id: old_tx_shipment_1_old.id)).to be_nil
        expect(InventoryTransaction.find_by(id: old_tx_shipment_1_new.id)).to be_nil
      end

      it 'creates correct transactions for inventory_1 with updated qty' do
        tx = InventoryTransaction.find_by(operation: inventory_1)
        expect(tx.item_id).to eq(item.id)
        expect(tx.storage_id).to eq(storage.id)
        expect(tx.qty).to eq(8)
        expect(tx.batch_number).to eq("Receiving-#{inventory_1.id}")
      end

      it 'creates correct transactions for inventory_2' do
        tx = InventoryTransaction.find_by(operation: inventory_2)
        expect(tx.item_id).to eq(item.id)
        expect(tx.storage_id).to eq(storage.id)
        expect(tx.qty).to eq(10)
        expect(tx.batch_number).to eq("Receiving-#{inventory_2.id}")
      end

      it 'creates correct transactions for shipment_1 with total qty' do
        tx = InventoryTransaction.find_by(operation: shipment_1)
        expect(tx.item_id).to eq(item.id)
        expect(tx.storage_id).to eq(storage.id)
        expect(tx.qty).to eq(-8)
        expect(tx.batch_number).to eq("Receiving-#{inventory_1.id}") # should be oldef transaction by FIFO
      end
    end
  end
end
