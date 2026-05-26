require "rails_helper"

RSpec.describe ReceivingsController, type: :controller do
  # Use factory_bot to create a storage record instead of direct model creation
  let!(:storage) { create(:storage) }

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          receiving: {
            storage_id: storage.id,
            received_at: Time.current,
            stock_state: "draft",
            receiving_items_attributes: [
               { item_id: create(:item).id, qty: 10, cost: 5.0 }
            ]
          }
        }
      end

      # New context for processed stock_state
      let(:processed_params) do
        {
          receiving: {
            storage_id: storage.id,
            received_at: Time.current,
            stock_state: "processed",
            receiving_items_attributes: [
               { item_id: create(:item).id, qty: 5, cost: 3.0 }
            ]
          }
        }
      end

      it "creates a new Receiving and redirects to index" do
        expect { post :create, params: valid_params }.to change(Receiving, :count).by(1)
        expect(response).to redirect_to(receivings_path)
        expect(flash[:notice]).to eq("Receiving was successfully created.")
      end

      it "creates a new Receiving with processed state and triggers ReceivingProcess" do
        # Stub the service to verify it is invoked without executing its internals
        receiving_instance = instance_double("ReceivingProcess")
        expect(::ReceivingProcess).to receive(:new).with(an_instance_of(Receiving)).and_return(receiving_instance)
        expect(receiving_instance).to receive(:call)

        expect { post :create, params: processed_params }.to change(Receiving, :count).by(1)
        expect(response).to redirect_to(receivings_path)
        expect(flash[:notice]).to eq("Receiving was successfully created.")
        expect(Receiving.last.stock_state).to eq("processed")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { receiving: { storage_id: nil, received_at: nil } }
      end

      it "does not create a Receiving and re-renders the new template" do
        expect { post :create, params: invalid_params }.not_to change(Receiving, :count)
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
