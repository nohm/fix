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

ActiveRecord::Schema.define(version: 20140206105153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appliances", force: true do |t|
    t.string   "name"
    t.string   "abb"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "preview_file_name"
    t.string   "preview_content_type"
    t.integer  "preview_file_size"
    t.datetime "preview_updated_at"
  end

  create_table "attachments", force: true do |t|
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
  end

  add_index "attachments", ["entry_id"], name: "index_attachments_on_entry_id", using: :btree

  create_table "broadcasts", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_ids"
  end

  create_table "classifications", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "title"
    t.string   "short"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abb"
    t.string   "address"
  end

  create_table "entries", force: true do |t|
    t.string   "number"
    t.string   "serialnum"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "defect"
    t.string   "ordered"
    t.integer  "repaired"
    t.integer  "ready"
    t.integer  "scrap"
    t.integer  "accessoires"
    t.integer  "test"
    t.integer  "sent"
    t.integer  "invoice_id"
    t.string   "repair"
    t.string   "testera"
    t.string   "testerb"
    t.integer  "classifications_id"
    t.string   "status"
    t.integer  "company_id"
    t.integer  "type_id"
  end

  add_index "entries", ["classifications_id"], name: "index_entries_on_classifications_id", using: :btree
  add_index "entries", ["company_id"], name: "index_entries_on_company_id", using: :btree
  add_index "entries", ["invoice_id"], name: "index_entries_on_invoice_id", using: :btree
  add_index "entries", ["type_id"], name: "index_entries_on_type_id", using: :btree

  create_table "invoices", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  add_index "invoices", ["company_id"], name: "index_invoices_on_company_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "stats", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "types", force: true do |t|
    t.string   "brand"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "typenum"
    t.decimal  "test_price",   precision: 5, scale: 2
    t.decimal  "repair_price", precision: 5, scale: 2
    t.decimal  "scrap_price",  precision: 5, scale: 2
    t.integer  "appliance_id"
  end

  add_index "types", ["appliance_id"], name: "index_types_on_appliance_id", using: :btree
  add_index "types", ["company_id"], name: "index_types_on_company_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "language",               default: "en"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
