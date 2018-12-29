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

ActiveRecord::Schema.define(version: 2018_12_25_085356) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.integer "entity_id"
    t.string "entity_type"
    t.string "comment_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "country_region_cities", force: :cascade do |t|
    t.string "country_name"
    t.string "country_iso"
    t.string "country_printable_name"
    t.string "country_iso3"
    t.integer "country_numcode"
    t.string "region_name"
    t.integer "region_id"
    t.string "city_name_en"
    t.string "city_name_he"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city_name"
    t.string "place_id"
  end

  create_table "salons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "org_id"
    t.integer "country_region_city_id"
    t.string "address"
    t.integer "floor"
    t.boolean "elevator"
    t.date "event_date"
    t.datetime "event_time"
    t.string "event_language", default: "hebrew"
    t.boolean "survivor_needed"
    t.boolean "strangers", default: true
    t.text "public_text"
    t.integer "max_guests"
    t.text "inside_text"
    t.integer "user_id"
    t.integer "witness_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.integer "user_id"
    t.string "entity_type"
    t.integer "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_salons", force: :cascade do |t|
    t.integer "user_id"
    t.integer "salon_id"
    t.integer "guest_amount"
    t.boolean "approved"
    t.boolean "canceled"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "full_name"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "witness_salons", force: :cascade do |t|
    t.integer "salon"
    t.integer "user_id"
    t.boolean "first_contactd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "witness_years", force: :cascade do |t|
    t.integer "witness_id"
    t.integer "year"
    t.boolean "available_day1"
    t.boolean "available_day2"
    t.boolean "available_day3"
    t.boolean "available_day4"
    t.boolean "available_day5"
    t.boolean "available_day6"
    t.boolean "available_day7"
    t.boolean "can_morning"
    t.boolean "can_afternoon"
    t.boolean "can_evening"
    t.boolean "first_staff_contacted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "witnesses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "country_region_city_id"
    t.string "address"
    t.boolean "can_morning"
    t.boolean "can_afternoon"
    t.boolean "can_evening"
    t.boolean "free_on_day"
    t.boolean "special_population"
    t.boolean "available_day1"
    t.boolean "available_day2"
    t.boolean "available_day3"
    t.boolean "available_day4"
    t.boolean "available_day5"
    t.boolean "available_day6"
    t.boolean "available_day7"
    t.string "contact_name"
    t.string "contact_phone"
    t.string "witness_type"
    t.string "language"
    t.boolean "stairs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "special_needs"
    t.boolean "seminar_required"
    t.string "free_text"
    t.string "additional_phone"
    t.boolean "archived"
    t.string "wheelchair", default: "false"
    t.boolean "hearing_impairment"
    t.boolean "visual_impairment"
  end

end
