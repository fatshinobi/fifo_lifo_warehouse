# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_05_180000) do
  create_table "inventory_transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "batch_number"
    t.decimal "cost", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.bigint "operation_id"
    t.string "operation_type"
    t.integer "qty"
    t.bigint "storage_id", null: false
    t.datetime "transaction_time"
    t.datetime "updated_at", null: false
    t.index ["batch_number"], name: "index_inventory_transactions_on_batch_number"
    t.index ["item_id", "storage_id", "batch_number", "transaction_time"], name: "idx_on_item_id_storage_id_batch_number_transaction__288056d298"
    t.index ["item_id"], name: "index_inventory_transactions_on_item_id"
    t.index ["operation_type", "operation_id"], name: "index_inventory_transactions_on_operation"
    t.index ["storage_id"], name: "index_inventory_transactions_on_storage_id"
    t.index ["transaction_time"], name: "index_inventory_transactions_on_transaction_time"
  end

  create_table "items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "cost", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "receiving_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "cost", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.decimal "price", precision: 8, scale: 2
    t.integer "qty"
    t.bigint "receiving_id", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_receiving_items_on_item_id"
    t.index ["receiving_id"], name: "index_receiving_items_on_receiving_id"
  end

  create_table "receivings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "received_at"
    t.bigint "storage_id", null: false
    t.datetime "updated_at", null: false
    t.index ["storage_id"], name: "index_receivings_on_storage_id"
  end

  create_table "shipment_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.decimal "price", precision: 8, scale: 2
    t.integer "qty"
    t.bigint "shipment_id", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_shipment_items_on_item_id"
    t.index ["shipment_id"], name: "index_shipment_items_on_shipment_id"
  end

  create_table "shipments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "shipped_at"
    t.bigint "storage_id", null: false
    t.datetime "updated_at", null: false
    t.index ["storage_id"], name: "index_shipments_on_storage_id"
  end

  create_table "storages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "location"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "inventory_transactions", "items"
  add_foreign_key "inventory_transactions", "storages"
  add_foreign_key "receiving_items", "items"
  add_foreign_key "receiving_items", "receivings"
  add_foreign_key "receivings", "storages"
  add_foreign_key "shipment_items", "items"
  add_foreign_key "shipment_items", "shipments"
  add_foreign_key "shipments", "storages"
end
