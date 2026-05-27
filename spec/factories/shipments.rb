FactoryBot.define do
factory :shipment do
  association :storage
  shipped_at { Time.current }
  stock_state { "draft" }

  # Allow tests to specify how many shipment_items to create
  transient do
    items_count { 1 }
  end

  after(:create) do |shipment, evaluator|
    create_list(:shipment_item, evaluator.items_count, shipment: shipment)
  end

  trait :processed do
    stock_state { "processed" }
  end

  trait :draft do
    stock_state { "draft" }
  end
end
end
