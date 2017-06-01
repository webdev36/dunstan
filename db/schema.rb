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

ActiveRecord::Schema.define(version: 20170601184252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "admin_users_roles", id: false, force: :cascade do |t|
    t.integer "admin_user_id"
    t.integer "role_id"
    t.index ["admin_user_id", "role_id"], name: "index_admin_users_roles_on_admin_user_id_and_role_id", using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "secret_question_id"
    t.integer  "user_id"
    t.string   "answer"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["secret_question_id"], name: "index_answers_on_secret_question_id", using: :btree
    t.index ["user_id"], name: "index_answers_on_user_id", using: :btree
  end

  create_table "keypad_histories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "keypad_id"
    t.string   "keypad_params"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["keypad_id"], name: "index_keypad_histories_on_keypad_id", using: :btree
    t.index ["user_id"], name: "index_keypad_histories_on_user_id", using: :btree
  end

  create_table "keypad_states", force: :cascade do |t|
    t.integer  "keypad_id"
    t.string   "open"
    t.string   "beell"
    t.string   "error"
    t.string   "power"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "bell",       limit: 255
    t.string   "status",     limit: 255
    t.string   "view",       limit: 255
    t.index ["keypad_id"], name: "index_keypad_states_on_keypad_id", using: :btree
  end

  create_table "keypads", force: :cascade do |t|
    t.string   "number"
    t.string   "password"
    t.string   "code"
    t.string   "status"
    t.integer  "admin_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "theme_number"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "secret_questions", force: :cascade do |t|
    t.string   "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_keypads", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "keypad_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "door_name"
    t.index ["keypad_id"], name: "index_user_keypads_on_keypad_id", using: :btree
    t.index ["user_id"], name: "index_user_keypads_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.boolean  "verified",               default: false
    t.string   "avatar"
    t.integer  "user_type",              default: 0
    t.datetime "invited_at"
    t.integer  "invite_status",          default: 0
    t.integer  "keypad_id"
    t.string   "keypad_number"
    t.string   "keypad_code"
    t.string   "keypad_password"
    t.string   "token"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "answers", "secret_questions"
  add_foreign_key "answers", "users"
  add_foreign_key "keypad_histories", "keypads"
  add_foreign_key "keypad_histories", "users"
  add_foreign_key "keypad_states", "keypads"
  add_foreign_key "user_keypads", "keypads"
  add_foreign_key "user_keypads", "users"
end
