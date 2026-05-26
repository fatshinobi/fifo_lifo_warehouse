FactoryBot.define do
  factory :item do
    name { "Test Item" }
    description { "This is a test item." }
    cost { 9.99 }
    # Use the enum symbol instead of a raw integer to avoid ArgumentError
    # Use add_attribute to avoid conflict with Kernel#method
    add_attribute(:method) { :fifo }
  end
end
