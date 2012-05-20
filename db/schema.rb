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

ActiveRecord::Schema.define(:version => 20120520043312) do

  create_table "folio_roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "folio_users", :force => true do |t|
    t.integer  "folio_id"
    t.integer  "user_id"
    t.integer  "folio_role_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "folio_users", ["folio_id"], :name => "index_folio_users_on_folio_id"
  add_index "folio_users", ["folio_role_id"], :name => "index_folio_users_on_folio_role_id"
  add_index "folio_users", ["user_id"], :name => "index_folio_users_on_user_id"

  create_table "folios", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "organisation_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "folios", ["organisation_id"], :name => "index_folios_on_organisation_id"

  create_table "organisation_users", :force => true do |t|
    t.integer  "organisation_id"
    t.integer  "user_id"
    t.boolean  "admin"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "organisation_users", ["organisation_id"], :name => "index_organisation_users_on_organisation_id"
  add_index "organisation_users", ["user_id"], :name => "index_organisation_users_on_user_id"

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.integer  "invitation_organisation_id"
    t.boolean  "invitation_organisation_admin"
    t.integer  "invitation_folio_id"
    t.integer  "invitation_folio_role_id"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  add_foreign_key "folio_users", "folio_roles", :name => "folio_users_folio_role_id_fk", :dependent => :delete
  add_foreign_key "folio_users", "folios", :name => "folio_users_folio_id_fk", :dependent => :delete
  add_foreign_key "folio_users", "users", :name => "folio_users_user_id_fk", :dependent => :delete

  add_foreign_key "folios", "organisations", :name => "folios_organisation_id_fk", :dependent => :delete

  add_foreign_key "organisation_users", "organisations", :name => "organisation_users_organisation_id_fk", :dependent => :delete
  add_foreign_key "organisation_users", "users", :name => "organisation_users_user_id_fk", :dependent => :delete

  add_foreign_key "users", "folio_roles", :name => "users_invitation_folio_role_id_fk", :column => "invitation_folio_role_id"
  add_foreign_key "users", "folios", :name => "users_invitation_folio_id_fk", :column => "invitation_folio_id"
  add_foreign_key "users", "organisations", :name => "users_invitation_organisation_id_fk", :column => "invitation_organisation_id"

end
