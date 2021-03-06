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

ActiveRecord::Schema.define(:version => 20110309223238) do

  create_table "administratorships", :force => true do |t|
    t.integer "administrator_id"
    t.integer "site_id"
  end

  add_index "administratorships", ["administrator_id", "site_id"], :name => "index_administratorships_on_administrator_id_and_site_id", :unique => true

  create_table "assets", :force => true do |t|
    t.integer  "site_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_statements", :force => true do |t|
    t.integer  "site_id"
    t.date     "disbursed_on"
    t.date     "funds_available"
    t.datetime "starting"
    t.datetime "ending"
    t.decimal  "total_raised",    :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "total_fees",      :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "total_due",       :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaign_statements", ["disbursed_on"], :name => "index_campaign_statements_on_disbursed_on"
  add_index "campaign_statements", ["site_id"], :name => "index_campaign_statements_on_site_id"

  create_table "contribution_transactions", :force => true do |t|
    t.integer  "contribution_id"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "reference"
    t.string   "message"
    t.string   "action"
    t.text     "params"
    t.boolean  "test"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contributions", :force => true do |t|
    t.integer  "site_id"
    t.string   "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "status"
    t.string   "ip"
    t.string   "employer"
    t.string   "occupation"
    t.boolean  "compliance_confirmation"
    t.text     "compliance_statement"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.string   "card_display_number"
    t.integer  "card_month"
    t.integer  "card_year"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "phone"
    t.boolean  "test"
    t.decimal  "amount",                                :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "processing_fees",                       :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "net_amount",                            :precision => 8, :scale => 2, :default => 0.0
    t.string   "transaction_id",          :limit => 10
    t.string   "refund_transaction_id",   :limit => 10
    t.boolean  "legacy",                                                              :default => false
    t.integer  "campaign_statement_id"
    t.date     "disbursed_on"
  end

  add_index "contributions", ["campaign_statement_id"], :name => "index_contributions_on_campaign_statement_id"
  add_index "contributions", ["disbursed_on"], :name => "index_contributions_on_disbursed_on"
  add_index "contributions", ["email"], :name => "index_contributions_on_email"
  add_index "contributions", ["last_name", "first_name"], :name => "index_contributions_on_last_name_and_first_name"
  add_index "contributions", ["order_id"], :name => "index_contributions_on_order_id", :unique => true
  add_index "contributions", ["site_id"], :name => "index_contributions_on_site_id"
  add_index "contributions", ["status"], :name => "index_contributions_on_status"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "items", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "site_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "title"
    t.string   "slug"
    t.string   "permalink"
    t.boolean  "published",             :default => false
    t.boolean  "show_in_navigation",    :default => false
    t.string   "template_name"
    t.text     "body"
    t.string   "article_template_name"
  end

  add_index "items", ["parent_id", "published", "type", "lft"], :name => "by_parent_published_type_and_lft"
  add_index "items", ["permalink", "site_id", "published"], :name => "by_permalink_site_and_published"
  add_index "items", ["site_id", "parent_id", "published", "show_in_navigation"], :name => "by_site_parent_published_and_nav"

  create_table "liquid_templates", :force => true do |t|
    t.integer  "theme_id",   :null => false
    t.string   "type",       :null => false
    t.string   "filename",   :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "liquid_templates", ["theme_id", "filename"], :name => "index_liquid_templates_on_theme_id_and_filename"

  create_table "progress_trackers", :force => true do |t|
    t.integer  "site_id"
    t.boolean  "theme_customized",         :default => false
    t.boolean  "contact_info_entered",     :default => false
    t.boolean  "candidate_photo_uploaded", :default => false
    t.boolean  "social_networks_added",    :default => false
    t.boolean  "custom_domain_setup",      :default => false
    t.boolean  "content_created",          :default => false
    t.boolean  "fundraising_activated",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
    t.string   "custom_domain"
    t.integer  "theme_id"
    t.string   "name"
    t.string   "subhead"
    t.text     "keywords"
    t.text     "description"
    t.text     "disclaimer"
    t.string   "campaign_email"
    t.string   "campaign_phone"
    t.string   "twitter_username"
    t.string   "facebook_page_id"
    t.string   "flickr_username"
    t.string   "youtube_username"
    t.string   "google_analytics_id"
    t.string   "paypal_email"
    t.integer  "owner_id"
    t.string   "campaign_monitor_password"
    t.string   "supporter_list_id"
    t.string   "contributor_list_id"
    t.string   "candidate_photo"
    t.text     "eligibility_statement"
    t.string   "campaign_legal_name"
    t.string   "campaign_street"
    t.string   "campaign_city"
    t.string   "campaign_state"
    t.string   "campaign_zip"
    t.string   "time_zone",                     :default => "Pacific Time (US & Canada)"
    t.boolean  "active",                        :default => false
    t.string   "credit_card_token"
    t.datetime "credit_card_expiration"
    t.string   "subscription_id"
    t.integer  "subscription_billing_cycle"
    t.boolean  "can_accept_contributions",      :default => false
    t.integer  "max_contribution_amount",       :default => 2400
    t.string   "mongo_theme_id"
    t.string   "mongo_theme_version_id"
    t.string   "mongo_theme_customization_id"
    t.integer  "suggested_contribution_amount"
  end

  add_index "sites", ["custom_domain"], :name => "index_sites_on_custom_domain", :unique => true
  add_index "sites", ["mongo_theme_id"], :name => "index_sites_on_mongo_theme_id"
  add_index "sites", ["mongo_theme_version_id"], :name => "index_sites_on_mongo_theme_version_id"
  add_index "sites", ["subdomain"], :name => "index_sites_on_subdomain", :unique => true

  create_table "sms_campaigns", :force => true do |t|
    t.integer  "site_id"
    t.integer  "created_by"
    t.datetime "created_at"
    t.string   "status"
    t.string   "message"
    t.integer  "recipients_count", :default => 0
  end

  create_table "sms_messages", :force => true do |t|
    t.integer "sms_campaign_id"
    t.integer "recipient_id"
  end

  create_table "supporters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  :null => false
    t.string   "name_prefix"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name_suffix"
    t.string   "phone"
    t.string   "thoroughfare"
    t.string   "locality"
    t.string   "subadministrative_area"
    t.string   "administrative_area"
    t.string   "country"
    t.string   "postal_code"
    t.string   "mobile_phone"
    t.float    "lat"
    t.float    "lng"
  end

  add_index "supporters", ["email"], :name => "index_supporters_on_email", :unique => true
  add_index "supporters", ["last_name", "first_name"], :name => "index_supporters_on_last_name_and_first_name"

  create_table "supporterships", :force => true do |t|
    t.integer  "supporter_id"
    t.integer  "site_id"
    t.boolean  "receive_email", :default => false
    t.boolean  "receive_sms",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supporterships", ["supporter_id", "site_id"], :name => "index_supporterships_on_supporter_id_and_site_id", :unique => true

  create_table "theme_assets", :force => true do |t|
    t.integer "theme_id"
    t.string  "file"
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "code"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                                                 :null => false
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "login_count",             :default => 0,                            :null => false
    t.integer  "failed_login_count",      :default => 0,                            :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "super_admin",             :default => false
    t.string   "time_zone",               :default => "Pacific Time (US & Canada)"
    t.boolean  "accepted_campaign_terms", :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["single_access_token"], :name => "index_users_on_single_access_token"

end
