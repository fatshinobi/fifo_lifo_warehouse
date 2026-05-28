FactoryBot.define do
  factory :transfer do
    association :storage
    association :storage_to, factory: :storage
    transferred_at { Time.current }
    stock_state { "draft" }

    transient do
      items_count { 2 }
    end

    after(:create) do |transfer, evaluator|
      create_list(:transfer_item, evaluator.items_count, transfer: transfer)
    end

    trait :processed do
      stock_state { "processed" }
    end

    trait :draft do
      stock_state { "draft" }
    end
  end

  factory :transfer_item do
    association :transfer
    association :item
    qty { 1 }
  end
end
