require "rails_helper"

RSpec.describe ShipmentsController, type: :controller do
  let!(:storage) { create(:storage) }
  let!(:item) { create(:item) }

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          shipment: {
            storage_id: storage.id,
            shipped_at: Time.current,
            stock_state: "draft",
            shipment_items_attributes: [
              { item_id: item.id, qty: 5, price: 20.0 }
            ]
          }
        }
      end

      it "creates a new Shipment and redirects to index" do
        expect { post :create, params: valid_params }.to change(Shipment, :count).by(1)
        expect(response).to redirect_to(shipments_path)
        expect(flash[:notice]).to eq("Shipment was successfully created.")
      end
    end

    context "with processed state" do
      let(:processed_params) do
        {
          shipment: {
            storage_id: storage.id,
            shipped_at: Time.current,
            stock_state: "processed",
            shipment_items_attributes: [
              { item_id: item.id, qty: 3, price: 15.0 }
            ]
          }
        }
      end

      it "creates a Shipment and triggers ShipmentProcess" do
        shipment_instance = instance_double("ShipmentProcess")
        expect(::ShipmentProcess).to receive(:new).with(an_instance_of(Shipment)).and_return(shipment_instance)
        expect(shipment_instance).to receive(:call)

        expect { post :create, params: processed_params }.to change(Shipment, :count).by(1)
        expect(response).to redirect_to(shipments_path)
        expect(flash[:notice]).to eq("Shipment was successfully created.")
        expect(Shipment.last.stock_state).to eq("processed")
      end
    end
  end

  describe "PATCH #update" do
    let!(:shipment) { create(:shipment, storage: storage, stock_state: "draft") }

    context "with valid parameters" do
      let(:valid_update_params) do
        {
          id: shipment.id,
          shipment: {
            stock_state: "processed",
            shipment_items_attributes: shipment.shipment_items.map do |si|
              { id: si.id, qty: si.qty + 1, price: si.price, _destroy: false }
            end
          }
        }
      end

      it "updates the Shipment and redirects to index" do
        shipment_instance = instance_double("ShipmentProcess")
        expect(::ShipmentProcess).to receive(:new).with(an_instance_of(Shipment)).and_return(shipment_instance)
        expect(shipment_instance).to receive(:call)

        patch :update, params: valid_update_params
        shipment.reload
        expect(response).to redirect_to(shipments_path)
        expect(flash[:notice]).to eq("Shipment was successfully updated.")
        expect(shipment.stock_state).to eq("processed")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { id: shipment.id, shipment: { storage_id: nil } }
      end

      it "does not update and re-renders edit" do
        patch :update, params: invalid_params
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
