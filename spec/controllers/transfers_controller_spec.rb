require "rails_helper"

RSpec.describe TransfersController, type: :controller do
  let!(:storage) { create(:storage) }
  let!(:storage_to) { create(:storage) }

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          transfer: {
            storage_id: storage.id,
            storage_to_id: storage_to.id,
            transferred_at: Time.current,
            stock_state: "draft",
            transfer_items_attributes: [
              { item_id: create(:item).id, qty: 10 }
            ]
          }
        }
      end

      let(:processed_params) do
        {
          transfer: {
            storage_id: storage.id,
            storage_to_id: storage_to.id,
            transferred_at: Time.current,
            stock_state: "processed",
            transfer_items_attributes: [
              { item_id: create(:item).id, qty: 5 }
            ]
          }
        }
      end

      it "creates a new Transfer and redirects to index" do
        expect { post :create, params: valid_params }.to change(Transfer, :count).by(1)
        expect(response).to redirect_to(transfers_path)
        expect(flash[:notice]).to eq("Transfer was successfully created.")
      end

      it "creates a processed Transfer and triggers TransferProcess" do
        transfer_instance = instance_double("TransferProcess")
        expect(::TransferProcess).to receive(:new).with(an_instance_of(Transfer)).and_return(transfer_instance)
        expect(transfer_instance).to receive(:call)

        expect { post :create, params: processed_params }.to change(Transfer, :count).by(1)
        expect(response).to redirect_to(transfers_path)
        expect(flash[:notice]).to eq("Transfer was successfully created.")
        expect(Transfer.last.stock_state).to eq("processed")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { transfer: { storage_id: nil, storage_to_id: nil } }
      end

      it "does not create a Transfer and re-renders the new template" do
        expect { post :create, params: invalid_params }.not_to change(Transfer, :count)
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH #update" do
    let!(:transfer) { create(:transfer, storage: storage, storage_to: storage_to, stock_state: "draft") }

    context "with valid parameters" do
      let(:valid_update_params) do
        {
          id: transfer.id,
          transfer: {
            stock_state: "processed",
            transfer_items_attributes: transfer.transfer_items.map do |ti|
              { id: ti.id, qty: ti.qty + 1, _destroy: false }
            end
          }
        }
      end

      it "updates the Transfer and redirects to index" do
        transfer_instance = instance_double("TransferProcess")
        expect(::TransferProcess).to receive(:new).with(an_instance_of(Transfer)).and_return(transfer_instance)
        expect(transfer_instance).to receive(:call)

        patch :update, params: valid_update_params
        transfer.reload
        expect(response).to redirect_to(transfers_path)
        expect(flash[:notice]).to eq("Transfer was successfully updated.")
        expect(transfer.stock_state).to eq("processed")
      end
    end

    context "with invalid parameters" do
      let(:invalid_update_params) do
        { id: transfer.id, transfer: { storage_id: nil } }
      end

      it "does not update the Transfer and re-renders edit" do
        patch :update, params: invalid_update_params
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
