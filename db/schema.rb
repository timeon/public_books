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

ActiveRecord::Schema.define(version: 20170407062310) do

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "authors", force: true do |t|
    t.string   "name"
    t.string   "english_name"
    t.text     "description"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",      default: false
  end

  create_table "contacts", force: true do |t|
    t.string   "home_phone"
    t.string   "street_no_and_name"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "adult_1_first_name"
    t.string   "adult_1_last_name"
    t.string   "adult_1_chinese_name"
    t.string   "adult_1_email"
    t.string   "adult_1_phone"
    t.integer  "adult_1_phone_ext"
    t.string   "adult_2_first_name"
    t.string   "adult_2_last_name"
    t.string   "adult_2_chinese_name"
    t.string   "adult_2_email"
    t.string   "adult_2_phone"
    t.integer  "adult_2_phone_ext"
    t.string   "child_1_relation"
    t.string   "child_1_first_name"
    t.string   "child_1_last_name"
    t.string   "child_1_chinese_name"
    t.string   "child_2_relation"
    t.string   "child_2_first_name"
    t.string   "child_2_last_name"
    t.string   "child_2_chinese_name"
    t.string   "child_3_relation"
    t.string   "child_3_first_name"
    t.string   "child_3_last_name"
    t.string   "child_3_chinese_name"
    t.string   "child_4_relation"
    t.string   "child_4_first_name"
    t.string   "child_4_last_name"
    t.string   "child_4_chinese_name"
    t.string   "child_5_relation"
    t.string   "child_5_first_name"
    t.string   "child_5_last_name"
    t.string   "child_5_chinese_name"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "photo_number"
    t.integer  "user_id"
    t.boolean  "verified"
    t.boolean  "disabled"
    t.boolean  "one_more_year"
    t.string   "key"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id", using: :btree

  create_table "courses", force: true do |t|
    t.integer  "category_id"
    t.integer  "medium_id"
    t.integer  "format_id"
    t.integer  "author_id"
    t.string   "name"
    t.string   "english_name"
    t.text     "description"
    t.string   "source_url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",             default: false
    t.string   "image_url"
    t.string   "subtitle"
  end

  add_index "courses", ["author_id"], name: "index_courses_on_author_id", using: :btree
  add_index "courses", ["category_id"], name: "index_courses_on_category_id", using: :btree
  add_index "courses", ["format_id"], name: "index_courses_on_format_id", using: :btree
  add_index "courses", ["medium_id"], name: "index_courses_on_medium_id", using: :btree

  create_table "families", force: true do |t|
    t.integer  "user_id"
    t.string   "phone"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "verified"
    t.boolean  "disabled"
    t.boolean  "one_more_year"
    t.string   "key"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "family_name"
    t.boolean  "sent"
    t.datetime "verified_at"
    t.datetime "sent_at"
  end

  add_index "families", ["user_id"], name: "index_families_on_user_id", using: :btree

  create_table "formats", force: true do |t|
    t.string   "name"
    t.integer  "media_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "formats", ["media_id"], name: "index_formats_on_media_id", using: :btree

  create_table "lessons", force: true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.string   "description"
    t.text     "body"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_url"
    t.integer  "author_id"
    t.integer  "row_order"
    t.string   "style",              default: ""
    t.boolean  "public",             default: true
    t.boolean  "is_file",            default: false
  end

  add_index "lessons", ["author_id"], name: "index_lessons_on_author_id", using: :btree
  add_index "lessons", ["course_id"], name: "index_lessons_on_course_id", using: :btree

  create_table "media", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.string   "position"
    t.integer  "order"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.integer  "family_id"
    t.string   "relation"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "chinese_name"
    t.string   "email"
    t.string   "phone"
    t.integer  "phone_ext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["family_id"], name: "index_people_on_family_id", using: :btree

  create_table "properties", force: true do |t|
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "properties", ["resource_id", "resource_type"], name: "index_properties_on_resource_id_and_resource_type", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.string   "gender"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "authentication_token"
    t.string   "key"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
