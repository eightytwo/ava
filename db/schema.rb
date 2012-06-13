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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120613052915) do

  create_table "audio_visual_categories", :force => true do |t|
    t.integer  "organisation_id",                :null => false
    t.string   "name",                           :null => false
    t.integer  "status_type_id",  :default => 1, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "audio_visual_categories", ["organisation_id"], :name => "index_audio_visual_categories_on_organisation_id"

  create_table "audio_visuals", :force => true do |t|
    t.integer  "user_id",                                     :null => false
    t.integer  "round_id"
    t.string   "title",                                       :null => false
    t.string   "description",                                 :null => false
    t.integer  "audio_visual_category_id"
    t.integer  "views",                    :default => 0
    t.decimal  "rating"
    t.string   "external_reference"
    t.string   "thumbnail"
    t.string   "music",                                       :null => false
    t.string   "location",                                    :null => false
    t.string   "production_notes",                            :null => false
    t.string   "tags",                                        :null => false
    t.integer  "length"
    t.boolean  "allow_critiquing",         :default => false, :null => false
    t.boolean  "allow_commenting",         :default => false, :null => false
    t.boolean  "public",                   :default => false, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "audio_visuals", ["audio_visual_category_id"], :name => "index_audio_visuals_on_audio_visual_category_id"
  add_index "audio_visuals", ["round_id"], :name => "index_audio_visuals_on_round_id"
  add_index "audio_visuals", ["user_id"], :name => "index_audio_visuals_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.integer  "audio_visual_id",  :null => false
    t.string   "content",          :null => false
    t.string   "reply"
    t.datetime "reply_created_at"
    t.datetime "reply_updated_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["audio_visual_id"], :name => "index_comments_on_audio_visual_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "critique_categories", :force => true do |t|
    t.integer  "organisation_id",                   :null => false
    t.string   "name",                              :null => false
    t.boolean  "critiquable",     :default => true, :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "status_type_id",  :default => 1,    :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "critique_categories", ["organisation_id"], :name => "index_critique_categories_on_organisation_id"

  create_table "critique_components", :force => true do |t|
    t.integer  "critique_id",          :null => false
    t.integer  "critique_category_id", :null => false
    t.string   "content"
    t.string   "reply"
    t.datetime "reply_created_at"
    t.datetime "reply_updated_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "critique_components", ["critique_category_id"], :name => "index_critique_components_on_critique_category_id"
  add_index "critique_components", ["critique_id"], :name => "index_critique_components_on_critique_id"

  create_table "critiques", :force => true do |t|
    t.integer  "audio_visual_id", :null => false
    t.integer  "user_id",         :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "critiques", ["audio_visual_id"], :name => "index_critiques_on_audio_visual_id"
  add_index "critiques", ["user_id"], :name => "index_critiques_on_user_id"

  create_table "folio_roles", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "folio_users", :force => true do |t|
    t.integer  "folio_id",      :null => false
    t.integer  "user_id",       :null => false
    t.integer  "folio_role_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "folio_users", ["folio_id"], :name => "index_folio_users_on_folio_id"
  add_index "folio_users", ["folio_role_id"], :name => "index_folio_users_on_folio_role_id"
  add_index "folio_users", ["user_id"], :name => "index_folio_users_on_user_id"

  create_table "folios", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "description",     :null => false
    t.integer  "organisation_id", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "folios", ["organisation_id"], :name => "index_folios_on_organisation_id"

  create_table "organisation_users", :force => true do |t|
    t.integer  "organisation_id",                    :null => false
    t.integer  "user_id",                            :null => false
    t.boolean  "admin",           :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "organisation_users", ["organisation_id"], :name => "index_organisation_users_on_organisation_id"
  add_index "organisation_users", ["user_id"], :name => "index_organisation_users_on_user_id"

  create_table "organisations", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description", :null => false
    t.string   "website"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rounds", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "folio_id",   :null => false
    t.date     "start_date", :null => false
    t.date     "end_date",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rounds", ["folio_id"], :name => "index_rounds_on_folio_id"

  create_table "status_types", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                       :default => "",    :null => false
    t.string   "encrypted_password",                          :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                               :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.boolean  "admin",                                       :default => false
    t.string   "invitation_token",              :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "username"
    t.integer  "status_type_id",                              :default => 1,     :null => false
    t.integer  "invitation_organisation_id"
    t.boolean  "invitation_organisation_admin"
    t.integer  "invitation_folio_id"
    t.integer  "invitation_folio_role_id"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  add_foreign_key "audio_visual_categories", "organisations", :name => "audio_visual_categories_organisation_id_fk", :dependent => :delete
  add_foreign_key "audio_visual_categories", "status_types", :name => "audio_visual_categories_status_type_id_fk", :dependent => :restrict

  add_foreign_key "audio_visuals", "audio_visual_categories", :name => "audio_visuals_audio_visual_category_id_fk", :dependent => :restrict
  add_foreign_key "audio_visuals", "rounds", :name => "audio_visuals_round_id_fk", :dependent => :delete
  add_foreign_key "audio_visuals", "users", :name => "audio_visuals_user_id_fk", :dependent => :delete

  add_foreign_key "comments", "audio_visuals", :name => "comments_audio_visual_id_fk", :dependent => :delete
  add_foreign_key "comments", "users", :name => "comments_user_id_fk", :dependent => :delete

  add_foreign_key "critique_categories", "organisations", :name => "critique_categories_organisation_id_fk", :dependent => :delete
  add_foreign_key "critique_categories", "status_types", :name => "critique_categories_status_type_id_fk", :dependent => :restrict

  add_foreign_key "critique_components", "critique_categories", :name => "critique_components_critique_category_id_fk", :dependent => :restrict
  add_foreign_key "critique_components", "critiques", :name => "critique_components_critique_id_fk", :dependent => :delete

  add_foreign_key "critiques", "audio_visuals", :name => "critiques_audio_visual_id_fk", :dependent => :delete
  add_foreign_key "critiques", "users", :name => "critiques_user_id_fk", :dependent => :restrict

  add_foreign_key "folio_users", "folio_roles", :name => "folio_users_folio_role_id_fk", :dependent => :restrict
  add_foreign_key "folio_users", "folios", :name => "folio_users_folio_id_fk", :dependent => :delete
  add_foreign_key "folio_users", "users", :name => "folio_users_user_id_fk", :dependent => :delete

  add_foreign_key "folios", "organisations", :name => "folios_organisation_id_fk", :dependent => :delete

  add_foreign_key "organisation_users", "organisations", :name => "organisation_users_organisation_id_fk", :dependent => :delete
  add_foreign_key "organisation_users", "users", :name => "organisation_users_user_id_fk", :dependent => :delete

  add_foreign_key "rounds", "folios", :name => "rounds_folio_id_fk", :dependent => :delete

  add_foreign_key "users", "folio_roles", :name => "users_invitation_folio_role_id_fk", :column => "invitation_folio_role_id", :dependent => :nullify
  add_foreign_key "users", "folios", :name => "users_invitation_folio_id_fk", :column => "invitation_folio_id", :dependent => :nullify
  add_foreign_key "users", "organisations", :name => "users_invitation_organisation_id_fk", :column => "invitation_organisation_id", :dependent => :nullify
  add_foreign_key "users", "status_types", :name => "users_status_type_id_fk", :dependent => :restrict

end
