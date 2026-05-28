require 'rails_helper'

RSpec.describe TransferProcess, type: :service do
  let(:storage_from) { create(:storage) }
  let(:storage_to) { create(:storage) }
  let(:item) { create(:item, method: :fifo) }

  describe '#call' do
    context 'when transfer is processed' do
      let(:transfer) do
        create(:transfer, :processed, storage: storage_from, storage_to: storage_to, items_count: 1)
      end

      before do
        allow(InventoryTransaction).to receive(:get_batches_for) do |_item_id, _storage_id, qty, _transferred_at, method: _method|
          [ { qty: 3, cost: 10.0, batch_number: "OLD_BATCH" },
            { qty: 5, cost: 10.0, batch_number: "NEW_BATCH" } ]
        end
      end

      it 'creates two InventoryTransactions for each transfer_item batch (outgoing and incoming)' do
        expect { TransferProcess.new(transfer).call }
          .to change(InventoryTransaction, :count).by(4)

        transfer_item = transfer.transfer_items.first
        transactions = InventoryTransaction.where(operation: transfer).order(:id)
        expect(transactions.size).to eq(4)

        outgoing_older_tx = transactions[0]
        incoming_older_tx = transactions[1]
        outgoing_newer_tx = transactions[2]
        incoming_newer_tx = transactions[3]

        expect(outgoing_older_tx.item.id).to eq(transfer_item.item.id)
        expect(outgoing_older_tx.storage.id).to eq(storage_from.id)
        expect(outgoing_older_tx.qty).to eq(-3)
        expect(outgoing_older_tx.batch_number).to eq('OLD_BATCH')

        expect(incoming_older_tx.item.id).to eq(transfer_item.item.id)
        expect(incoming_older_tx.storage.id).to eq(storage_to.id)
        expect(incoming_older_tx.qty).to eq(3)
        expect(incoming_older_tx.batch_number).to eq('OLD_BATCH')

        expect(outgoing_newer_tx.item.id).to eq(transfer_item.item.id)
        expect(outgoing_newer_tx.storage.id).to eq(storage_from.id)
        expect(outgoing_newer_tx.qty).to eq(-5)
        expect(outgoing_newer_tx.batch_number).to eq('NEW_BATCH')

        expect(incoming_newer_tx.item.id).to eq(transfer_item.item.id)
        expect(incoming_newer_tx.storage.id).to eq(storage_to.id)
        expect(incoming_newer_tx.qty).to eq(5)
        expect(incoming_newer_tx.batch_number).to eq('NEW_BATCH')
      end
    end

    context 'when transfer is a draft' do
      let(:transfer) { create(:transfer, :draft, storage: storage_from, storage_to: storage_to, items_count: 1) }

      before do
        create(:inventory_transaction, operation: transfer)
      end

      it 'removes all inventory transactions linked to the transfer' do
        expect { TransferProcess.new(transfer).call }
          .to change(InventoryTransaction, :count).by(-1)
      end
    end
  end
end