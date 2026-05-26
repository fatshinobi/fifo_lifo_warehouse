FactoryBot.define do
  factory :shipment do
    association :storage
    shipped_at { Time.current }
    stock_state { "draft" }
    # build a default shipment_item to satisfy nested attributes
    after(:build) do |shipment|
      shipment.shipment_items << build(:shipment_item, shipment: shipment) if shipment.shipment_items.empty?
    end
  end
end
