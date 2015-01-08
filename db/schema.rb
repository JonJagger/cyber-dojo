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

ActiveRecord::Schema.define(version: 20150108134622) do

  create_table "avatar_sessions", force: true do |t|
    t.string   "avatar"
    t.integer  "vote_count"
    t.integer  "dojo_start_point_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "avatar_sessions", ["dojo_start_point_id"], name: "index_avatar_sessions_on_dojo_start_point_id"

  create_table "dojo_start_points", force: true do |t|
    t.string   "dojo_id"
    t.string   "language"
    t.string   "exercise"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "traffic_lights", force: true do |t|
    t.integer  "tag"
    t.string   "content_hash"
    t.integer  "fork_count"
    t.integer  "avatar_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "colour"
  end

  add_index "traffic_lights", ["avatar_session_id"], name: "index_traffic_lights_on_avatar_session_id"

end
