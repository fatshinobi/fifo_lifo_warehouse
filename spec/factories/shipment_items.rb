FactoryBot.define do
  factory :shipment_item do
    association :shipment
    association :item
    qty { 1 }
    price { 10.0 }
  end
end
