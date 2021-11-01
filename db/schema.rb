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

ActiveRecord::Schema.define(version: 20210923134532) do

  create_table "applies", force: :cascade do |t|
    t.date "month"
    t.string "mark", default: "0"
    t.integer "user_id"
    t.string "user_name"
    t.string "authorizer"
    t.string "check_box"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "scheduled_end_time"
    t.datetime "changed_started_at"
    t.datetime "changed_finished_at"
    t.string "change_approval", default: "0"
    t.string "overtime_approval", default: "0"
    t.string "approval_authorizer", default: "1"
    t.string "note"
    t.string "overtime_note"
    t.string "check_box"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.string "base_id"
    t.string "base_name"
    t.string "base_kinds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade do |t|
    t.date "log_worked_on"
    t.integer "user_id"
    t.datetime "log_started_at"
    t.datetime "log_finished_at"
    t.datetime "log_changed_started_at"
    t.datetime "log_changed_finished_at"
    t.string "overtime_approval", default: "0"
    t.datetime "log_scheduled_end_time"
    t.string "approval_authorizer"
    t.string "note"
    t.string "overtime_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.boolean "superior", default: false
    t.string "affiliation"
    t.string "uid"
    t.string "employee_number"
    t.integer "base_id"
    t.datetime "basic_time", default: "2021-11-01 00:00:00"
    t.datetime "designated_work_start_time", default: "2021-11-01 00:00:00"
    t.datetime "designated_work_end_time", default: "2021-11-01 09:00:00"
    t.datetime "work_time", default: "2021-10-31 23:00:00"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
