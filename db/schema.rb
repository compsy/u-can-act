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

ActiveRecord::Schema.define(version: 20170420142715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invitation_tokens", force: :cascade do |t|
    t.integer  "response_id", null: false
    t.string   "token",       null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["response_id"], name: "index_invitation_tokens_on_response_id", unique: true, using: :btree
    t.index ["token"], name: "index_invitation_tokens_on_token", unique: true, using: :btree
  end

  create_table "measurements", force: :cascade do |t|
    t.integer  "questionnaire_id",             null: false
    t.integer  "protocol_id",                  null: false
    t.integer  "period"
    t.integer  "open_from_offset",             null: false
    t.integer  "open_duration"
    t.integer  "reward_points",    default: 0, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["protocol_id"], name: "index_measurements_on_protocol_id", using: :btree
    t.index ["questionnaire_id"], name: "index_measurements_on_questionnaire_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "type",         null: false
    t.string   "mobile_phone", null: false
    t.string   "first_name",   null: false
    t.string   "last_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["mobile_phone"], name: "index_people_on_mobile_phone", unique: true, using: :btree
  end

  create_table "protocol_subscriptions", force: :cascade do |t|
    t.integer  "person_id",   null: false
    t.integer  "protocol_id", null: false
    t.string   "state",       null: false
    t.datetime "start_date",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["person_id"], name: "index_protocol_subscriptions_on_person_id", using: :btree
    t.index ["protocol_id"], name: "index_protocol_subscriptions_on_protocol_id", using: :btree
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

  create_table "responses", force: :cascade do |t|
    t.integer  "protocol_subscription_id", null: false
    t.integer  "measurement_id",           null: false
    t.string   "content"
    t.datetime "open_from",                null: false
    t.datetime "opened_at"
    t.datetime "completed_at"
    t.string   "invited_state",            null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["measurement_id"], name: "index_responses_on_measurement_id", using: :btree
    t.index ["protocol_subscription_id"], name: "index_responses_on_protocol_subscription_id", using: :btree
  end

  add_foreign_key "invitation_tokens", "responses"
  add_foreign_key "measurements", "protocols"
  add_foreign_key "measurements", "questionnaires"
  add_foreign_key "protocol_subscriptions", "people"
  add_foreign_key "protocol_subscriptions", "protocols"
  add_foreign_key "responses", "measurements"
  add_foreign_key "responses", "protocol_subscriptions"
end
