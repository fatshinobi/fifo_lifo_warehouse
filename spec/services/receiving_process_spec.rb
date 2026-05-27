require 'rails_helper'

RSpec.describe ReceivingProcess, type: :service do
  let(:storage) { create(:storage) }
  let(:item)    { create(:item) }

  describe '#call' do
    context 'when receiving is processed' do
      let(:receiving) do
        create(:receiving, :processed, storage: storage, items_count: 2)
      end

      it 'creates an InventoryTransaction for each receiving_item' do
        expect { ReceivingProcess.new(receiving).call }
          .to change(InventoryTransaction, :count).by(2)

        inventory_item = receiving.receiving_items.first

        transaction = InventoryTransaction.where(operation: receiving).first
        expect(transaction.item.id).to eq(inventory_item.item.id)
        expect(transaction.storage.id).to eq(storage.id)
        expect(transaction.qty).to eq(inventory_item.qty)
        expect(transaction.cost).to eq(inventory_item.cost)
        expect(transaction.batch_number).to eq(receiving.formatted_id)
        expect(transaction.operation.id).to eq(receiving.id)
        expect(transaction.transaction_time).to eq(receiving.received_at)

        inventory_item_2 = receiving.receiving_items.last

        transaction_2 = InventoryTransaction.where(operation: receiving).last
        expect(transaction_2.item.id).to eq(inventory_item_2.item.id)
        expect(transaction_2.storage.id).to eq(storage.id)
        expect(transaction_2.qty).to eq(inventory_item_2.qty)
        expect(transaction_2.cost).to eq(inventory_item_2.cost)
        expect(transaction_2.batch_number).to eq(receiving.formatted_id)
        expect(transaction_2.operation.id).to eq(receiving.id)
        expect(transaction_2.transaction_time).to eq(receiving.received_at)
      end
    end

    context 'when receiving is a draft' do
      let(:receiving) { create(:receiving, :draft, storage: storage, items_count: 1) }

      before do
        # create existing transactions that should be removed
        create(:inventory_transaction, operation: receiving)
      end

      it 'removes all inventory transactions linked to the receiving' do
        expect { ReceivingProcess.new(receiving).call }
          .to change(InventoryTransaction, :count).by(-1)
      end
    end
  end
end
