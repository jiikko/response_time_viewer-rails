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

ActiveRecord::Schema.define(version: 20170417135105) do

  create_table "response_time_viewer_rails_access_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "path",           limit: 191,               null: false
    t.integer  "status",                       default: 0, null: false
    t.integer  "executing_time",               default: 0, null: false
    t.text     "error_trace",    limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["path"], name: "index_response_time_viewer_rails_access_logs_on_path", unique: true, using: :btree
  end

  create_table "response_time_viewer_rails_summarized_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "path",             limit: 191,               null: false
    t.string   "params",           limit: 191
    t.string   "path_with_params", limit: 191,               null: false
    t.datetime "summarized_at"
    t.integer  "device",                                     null: false
    t.integer  "merged_count",                               null: false
    t.float    "total_ms",         limit: 24,  default: 0.0, null: false
    t.float    "view_ms",          limit: 24,  default: 0.0, null: false
    t.float    "ar_ms",            limit: 24,  default: 0.0, null: false
    t.float    "solr_ms",          limit: 24,  default: 0.0, null: false
    t.index ["ar_ms"], name: "index_response_time_viewer_rails_summarized_requests_on_ar_ms", using: :btree
    t.index ["merged_count"], name: "index_summarized_requests_merged_count", using: :btree
    t.index ["path"], name: "index_summarized_requests_path", using: :btree
    t.index ["path_with_params"], name: "index_summarized_requests_path_with_params", using: :btree
    t.index ["solr_ms"], name: "index_response_time_viewer_rails_summarized_requests_on_solr_ms", using: :btree
    t.index ["summarized_at", "path"], name: "index_summarized_requests_summarized_at_path", using: :btree
    t.index ["total_ms"], name: "index_response_time_viewer_rails_summarized_requests_on_total_ms", using: :btree
    t.index ["view_ms"], name: "index_response_time_viewer_rails_summarized_requests_on_view_ms", using: :btree
  end

  create_table "response_time_viewer_rails_watching_url_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",                                          null: false
    t.integer  "watchi_urls_counter",               default: 0, null: false
    t.text     "memo",                limit: 65535
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "response_time_viewer_rails_watching_url_groups_urls", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "watching_url_group_id"
    t.integer  "watching_url_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["watching_url_group_id", "watching_url_id"], name: "index_watching_url_group_id_watching_url_id", unique: true, using: :btree
  end

  create_table "response_time_viewer_rails_watching_urls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "path",       limit: 191, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["path"], name: "index_response_time_viewer_rails_watching_urls_on_path", unique: true, using: :btree
  end

end
