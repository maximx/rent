# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160106015305) do

  create_table "attachments", force: :cascade do |t|
    t.integer  "attachable_id",     limit: 4
    t.string   "attachable_type",   limit: 255
    t.string   "file",              limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "image",             limit: 255
    t.integer  "file_size",         limit: 8
    t.string   "content_type",      limit: 255
    t.string   "original_filename", limit: 255
  end

  add_index "attachments", ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id", using: :btree

  create_table "banks", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "banks", ["code"], name: "index_banks_on_code", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "serial",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  create_table "delivers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "follower_id", limit: 4
    t.integer  "followed_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "follows", ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true, using: :btree

  create_table "item_collections", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "item_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "item_collections", ["user_id", "item_id"], name: "index_item_collections_on_user_id_and_item_id", unique: true, using: :btree

  create_table "item_delivers", force: :cascade do |t|
    t.integer  "item_id",    limit: 4
    t.integer  "deliver_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "item_delivers", ["item_id", "deliver_id"], name: "index_item_delivers_on_item_id_and_deliver_id", unique: true, using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.float    "price",          limit: 24
    t.integer  "period",         limit: 4,     default: 0
    t.string   "address",        limit: 255
    t.float    "deposit",        limit: 24,    default: 0.0
    t.text     "description",    limit: 65535
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "user_id",        limit: 4
    t.integer  "subcategory_id", limit: 4
    t.integer  "category_id",    limit: 4
    t.float    "latitude",       limit: 24
    t.float    "longitude",      limit: 24
    t.integer  "minimum_period", limit: 4,     default: 1
    t.integer  "city_id",        limit: 4
    t.float    "deliver_fee",    limit: 24,    default: 0.0
    t.string   "aasm_state",     limit: 255
    t.string   "product_id",     limit: 255
  end

  add_index "items", ["user_id", "product_id"], name: "index_items_on_user_id_and_product_id", using: :btree

  create_table "items_selections", force: :cascade do |t|
    t.integer  "item_id",      limit: 4
    t.integer  "vector_id",    limit: 4
    t.integer  "selection_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "items_selections", ["item_id", "vector_id"], name: "index_items_selections_on_item_id_and_vector_id", unique: true, using: :btree

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id",   limit: 4
    t.string  "unsubscriber_type", limit: 255
    t.integer "conversation_id",   limit: 4
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    limit: 255, default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type",                 limit: 255
    t.text     "body",                 limit: 65535
    t.string   "subject",              limit: 255,   default: ""
    t.integer  "sender_id",            limit: 4
    t.string   "sender_type",          limit: 255
    t.integer  "conversation_id",      limit: 4
    t.boolean  "draft",                              default: false
    t.string   "notification_code",    limit: 255
    t.integer  "notified_object_id",   limit: 4
    t.string   "notified_object_type", limit: 255
    t.string   "attachment",           limit: 255
    t.datetime "updated_at",                                         null: false
    t.datetime "created_at",                                         null: false
    t.boolean  "global",                             default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type", using: :btree

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id",     limit: 4
    t.string   "receiver_type",   limit: 255
    t.integer  "notification_id", limit: 4,                   null: false
    t.boolean  "is_read",                     default: false
    t.boolean  "trashed",                     default: false
    t.boolean  "deleted",                     default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "borrower_id",   limit: 4
    t.string   "borrower_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.float    "price",         limit: 24
  end

  add_index "orders", ["borrower_type", "borrower_id"], name: "index_orders_on_borrower_type_and_borrower_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",               limit: 4
    t.string   "name",                  limit: 255
    t.string   "address",               limit: 255
    t.string   "phone",                 limit: 255
    t.text     "description",           limit: 65535
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "bank_code",             limit: 255
    t.string   "bank_account",          limit: 255
    t.string   "confirmation_token",    limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.float    "latitude",              limit: 24
    t.float    "longitude",             limit: 24
    t.string   "user_type",             limit: 255
    t.string   "line",                  limit: 255
    t.string   "facebook",              limit: 255
    t.boolean  "send_mail",                           default: true
    t.boolean  "borrower_info_provide",               default: false
    t.string   "tel_phone",             limit: 255
  end

  add_index "profiles", ["phone"], name: "index_profiles_on_phone", using: :btree
  add_index "profiles", ["user_id", "user_type"], name: "index_profiles_on_user_id_and_user_type", using: :btree

  create_table "record_state_logs", force: :cascade do |t|
    t.integer  "record_id",     limit: 4
    t.string   "aasm_state",    limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "info",          limit: 255
    t.integer  "borrower_id",   limit: 4
    t.string   "borrower_type", limit: 255
  end

  add_index "record_state_logs", ["borrower_id", "borrower_type"], name: "index_record_state_logs_on_borrower_id_and_borrower_type", using: :btree

  create_table "records", force: :cascade do |t|
    t.integer  "item_id",       limit: 4
    t.integer  "borrower_id",   limit: 4
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "aasm_state",    limit: 255
    t.float    "price",         limit: 24
    t.float    "item_price",    limit: 24
    t.integer  "rent_days",     limit: 4
    t.float    "item_deposit",  limit: 24
    t.integer  "deliver_id",    limit: 4,   null: false
    t.float    "deliver_fee",   limit: 24
    t.string   "borrower_type", limit: 255
    t.integer  "order_id",      limit: 4
  end

  add_index "records", ["borrower_id", "borrower_type"], name: "index_records_on_borrower_id_and_borrower_type", using: :btree
  add_index "records", ["order_id"], name: "index_records_on_order_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "record_id",  limit: 4
    t.integer  "judger_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "user_role",  limit: 4
    t.text     "content",    limit: 65535
    t.integer  "rate",       limit: 4,     default: 2
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "reviews", ["record_id", "judger_id", "user_id"], name: "index_reviews_on_record_id_and_judger_id_and_user_id", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "selections", force: :cascade do |t|
    t.integer  "vector_id",  limit: 4
    t.integer  "tag_id",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "user_id",    limit: 4
  end

  add_index "selections", ["vector_id", "tag_id"], name: "index_selections_on_vector_id_and_tag_id", unique: true, using: :btree

  create_table "shopping_cart_items", force: :cascade do |t|
    t.integer "shopping_cart_id", limit: 4
    t.integer "item_id",          limit: 4
    t.float   "price",            limit: 24
    t.float   "deliver_fee",      limit: 24
    t.integer "deliver_id",       limit: 4
  end

  add_index "shopping_cart_items", ["shopping_cart_id", "item_id"], name: "index_shopping_cart_items_on_shopping_cart_id_and_item_id", using: :btree

  create_table "shopping_carts", force: :cascade do |t|
    t.integer "user_id",   limit: 4
    t.string  "user_type", limit: 255
  end

  add_index "shopping_carts", ["user_type", "user_id"], name: "index_shopping_carts_on_user_type_and_user_id", using: :btree

  create_table "subcategories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "category_id", limit: 4
    t.integer  "serial",      limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "account",                limit: 255
  end

  add_index "users", ["account"], name: "index_users_on_account", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "vectors", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.integer  "subcategory_id", limit: 4
    t.integer  "tag_id",         limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "vectors", ["user_id", "subcategory_id", "tag_id"], name: "index_vectors_on_user_id_and_subcategory_id_and_tag_id", unique: true, using: :btree

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
end
