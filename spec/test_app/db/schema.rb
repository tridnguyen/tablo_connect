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

ActiveRecord::Schema.define(version: 20151109173427) do

  create_table "tablo_connect_movies", force: :cascade do |t|
    t.integer  "tablo_id"
    t.string   "title"
    t.text     "description"
    t.integer  "release_year"
    t.datetime "air_date"
    t.integer  "image_id"
    t.integer  "copy_status",  default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "tablo_ip"
  end

  add_index "tablo_connect_movies", ["tablo_ip", "tablo_id"], name: "index_tablo_connect_movies_on_tablo_ip_and_tablo_id", unique: true
  add_index "tablo_connect_movies", ["title"], name: "index_tablo_connect_movies_on_title"

  create_table "tablo_connect_shows", force: :cascade do |t|
    t.integer  "tablo_id"
    t.string   "show"
    t.string   "title"
    t.text     "description"
    t.integer  "episode"
    t.integer  "season"
    t.date     "air_date"
    t.datetime "rec_date"
    t.integer  "image_id"
    t.integer  "copy_status", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "tablo_ip"
  end

  add_index "tablo_connect_shows", ["show"], name: "index_tablo_connect_shows_on_show"
  add_index "tablo_connect_shows", ["tablo_ip", "tablo_id"], name: "index_tablo_connect_shows_on_tablo_ip_and_tablo_id", unique: true

end
