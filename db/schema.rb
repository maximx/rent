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

ActiveRecord::Schema.define(version: 20150723022553) do

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

  create_table "items", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.float    "price",          limit: 24
    t.integer  "period",         limit: 4,     default: 1
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
    t.float    "down_payment",   limit: 24,    default: 0.0
  end

  create_table "pictures", force: :cascade do |t|
    t.integer  "imageable_id",   limit: 4
    t.string   "imageable_type", limit: 255
    t.string   "public_id",      limit: 255
    t.string   "name",           limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "pictures", ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "name",        limit: 255
    t.string   "address",     limit: 255
    t.string   "phone",       limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "item_id",    limit: 4
    t.text     "content",    limit: 65535
    t.integer  "user_id",    limit: 4
    t.text     "reply",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "rent_records", force: :cascade do |t|
    t.integer  "item_id",       limit: 4
    t.integer  "user_id",       limit: 4
    t.string   "name",          limit: 255
    t.string   "phone",         limit: 255
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "aasm_state",    limit: 255
    t.float    "price",         limit: 24
    t.datetime "booking_at"
    t.datetime "renting_at"
    t.datetime "withdrawed_at"
    t.datetime "returned_at"
  end

  create_table "requirements", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.string   "phone",       limit: 255
    t.string   "address",     limit: 255
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "user_id",     limit: 4
    t.float    "price",       limit: 24
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rent_record_id", limit: 4
    t.integer  "judger_id",      limit: 4
    t.integer  "user_id",        limit: 4
    t.integer  "user_role",      limit: 4
    t.text     "content",        limit: 65535
    t.integer  "rate",           limit: 4,     default: 2
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "reviews", ["rent_record_id", "judger_id", "user_id"], name: "index_reviews_on_rent_record_id_and_judger_id_and_user_id", unique: true, using: :btree

  create_table "subcategories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "category_id", limit: 4
    t.integer  "serial",      limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

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
    t.string   "name",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
