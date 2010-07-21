# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100721172138) do

  create_table "accesses", :force => true do |t|
    t.integer "accessor_id",                                    :null => false
    t.string  "accessor_type",   :limit => 100, :default => "", :null => false
    t.integer "accessable_id",                                  :null => false
    t.string  "accessable_type", :limit => 100, :default => "", :null => false
    t.integer "permission_id",                                  :null => false
  end

  add_index "accesses", ["accessable_id", "accessable_type"], :name => "index_accesses_on_accessable_id_and_accessable_type"
  add_index "accesses", ["accessor_id", "accessor_type"], :name => "index_accesses_on_accessor_id_and_accessor_type"

  create_table "account_groups", :force => true do |t|
    t.integer "account_id", :null => false
    t.integer "group_id",   :null => false
  end

  add_index "account_groups", ["account_id", "group_id"], :name => "account_groups_index"

  create_table "accounts", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name",                      :limit => 100, :default => ""
  end

  add_index "accounts", ["login"], :name => "index_accounts_on_login", :unique => true

  create_table "applications", :force => true do |t|
    t.string  "name",       :limit => 50,  :default => "", :null => false
    t.string  "short_name", :limit => 10,  :default => "", :null => false
    t.string  "desc",       :limit => 200, :default => "", :null => false
    t.integer "project_id",                                :null => false
  end

  add_index "applications", ["project_id"], :name => "index_applications_on_project_id"
  add_index "applications", ["short_name"], :name => "index_applications_on_short_name", :unique => true

  create_table "clients", :force => true do |t|
    t.string "name",       :limit => 50, :default => "", :null => false
    t.string "short_name", :limit => 10, :default => "", :null => false
  end

  add_index "clients", ["name"], :name => "index_clients_on_name", :unique => true
  add_index "clients", ["short_name"], :name => "index_clients_on_short_name", :unique => true

  create_table "deploy_processes", :force => true do |t|
    t.integer  "deploy_id",      :null => false
    t.integer  "environment_id", :null => false
    t.datetime "created_at",     :null => false
  end

  add_index "deploy_processes", ["deploy_id"], :name => "deploy_environment", :unique => true
  add_index "deploy_processes", ["environment_id"], :name => "unique_environment", :unique => true

  create_table "deploys", :force => true do |t|
    t.datetime "deployed_at",                                   :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "is_running",                                    :null => false
    t.boolean  "is_success",                                    :null => false
    t.integer  "environment_id",                                :null => false
    t.string   "log_file",       :limit => 200, :default => "", :null => false
    t.datetime "completed_at"
    t.string   "version",        :limit => 200, :default => ""
    t.text     "note"
    t.string   "path"
    t.integer  "deployed_by_id"
  end

  add_index "deploys", ["environment_id"], :name => "index_deploys_on_environment_id"
  add_index "deploys", ["log_file"], :name => "index_deploys_on_log_file", :unique => true

  create_table "environment_parameters", :force => true do |t|
    t.string  "name",           :limit => 200, :default => "",    :null => false
    t.text    "value",                                            :null => false
    t.integer "environment_id",                                   :null => false
    t.boolean "is_private",                    :default => false, :null => false
  end

  add_index "environment_parameters", ["environment_id"], :name => "index_environment_parameters_on_environment_id"

  create_table "environment_templates", :force => true do |t|
    t.string  "name"
    t.string  "include"
    t.integer "environment_id"
  end

  create_table "environments", :force => true do |t|
    t.string  "name",            :limit => 50,  :default => "",    :null => false
    t.string  "deployment_mode", :limit => 100, :default => "",    :null => false
    t.string  "desc",            :limit => 200, :default => "",    :null => false
    t.boolean "is_production",                  :default => false, :null => false
    t.integer "app_id"
  end

  add_index "environments", ["name"], :name => "index_environments_on_name_and_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string "name", :limit => 50,  :default => "", :null => false
    t.string "desc", :limit => 200, :default => "", :null => false
  end

  create_table "permissions", :force => true do |t|
    t.string "name", :limit => 20, :default => "", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string  "name",       :limit => 50,  :default => "", :null => false
    t.string  "short_name", :limit => 10,  :default => "", :null => false
    t.string  "desc",       :limit => 200, :default => "", :null => false
    t.integer "client_id",                                 :null => false
  end

  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"
  add_index "projects", ["name"], :name => "index_projects_on_name", :unique => true

end
