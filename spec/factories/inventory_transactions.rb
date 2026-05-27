FactoryBot.define do
  factory :inventory_transaction do
    association :item
    association :storage
    qty { 1 }
    cost { 1.0 }
    batch_number { "BATCH-#{SecureRandom.hex(4)}" }
    transaction_time { Time.current }
    association :operation, factory: :receiving
  end
end
