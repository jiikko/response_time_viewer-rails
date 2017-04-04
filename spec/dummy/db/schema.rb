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

ActiveRecord::Schema.define(version: 20170403143701) do

  create_table "response_time_viewer_rails_summarized_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "path",          limit: 191,               null: false
    t.string   "params",        limit: 191
    t.datetime "summarized_at"
    t.integer  "device",                                  null: false
    t.integer  "merged_count",                            null: false
    t.float    "total_ms",      limit: 24,  default: 0.0, null: false
    t.float    "view_ms",       limit: 24,  default: 0.0, null: false
    t.float    "ar_ms",         limit: 24,  default: 0.0, null: false
    t.float    "solr_ms",       limit: 24,  default: 0.0, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["summarized_at", "path"], name: "index_summarized_requests_summarized_at_path", using: :btree
  end

end
