class Item < ApplicationRecord
  enum :method, { fifo: 0, lifo: 1 }
end
