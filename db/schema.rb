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

ActiveRecord::Schema.define(version: 20170413095956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "people", force: :cascade do |t|
    t.string   "type",         null: false
    t.string   "mobile_phone", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["mobile_phone"], name: "index_people_on_mobile_phone", unique: true, using: :btree
  end

  create_table "protocols", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "duration",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_protocols_on_name", unique: true, using: :btree
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "content",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_questionnaires_on_name", unique: true, using: :btree
  end

end
