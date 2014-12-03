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

ActiveRecord::Schema.define(version: 20141203051212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "listings", force: true do |t|
    t.string   "address"
    t.string   "title"
    t.integer  "price"
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.integer  "sq_ft"
    t.string   "web_address"
    t.boolean  "sold"
    t.text     "description"
    t.string   "short_description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",            default: false
  end

  add_index "listings", ["user_id"], name: "index_listings_on_user_id", using: :btree

  create_table "photos", force: true do |t|
    t.string   "file_name"
    t.string   "file_content_type"
    t.integer  "file_size"
    t.string   "url"
    t.string   "key"
    t.string   "bucket"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "listing_id"
    t.boolean  "deleted",           default: false
    t.datetime "deleted_at"
  end

  add_index "photos", ["listing_id"], name: "index_photos_on_listing_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "profile_pic"
    t.string   "logo"
    t.string   "name"
    t.string   "web_site"
    t.string   "contact_email"
    t.string   "phone_number"
    t.string   "dre_number"
    t.text     "tag_line"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "sites", force: true do |t|
    t.string   "custom_url"
    t.string   "bucket"
    t.boolean  "active"
    t.integer  "listing_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["listing_id"], name: "index_sites_on_listing_id", using: :btree
  add_index "sites", ["user_id"], name: "index_sites_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "admin",                  default: false
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
