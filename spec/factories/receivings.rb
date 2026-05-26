FactoryBot.define do
  factory :receiving do
    association :storage
    received_at { Time.current }
    stock_state { "draft" }

    # Create a few receiving_items by default so update tests have data to work with
    transient do
      items_count { 2 }
    end

    after(:create) do |receiving, evaluator|
      create_list(:receiving_item, evaluator.items_count, receiving: receiving)
    end
  end

  factory :receiving_item do
    association :receiving
    association :item
    qty { 1 }
    cost { 1.0 }
  end
end
