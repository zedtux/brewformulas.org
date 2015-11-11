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

ActiveRecord::Schema.define(version: 20131207105221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "homebrew_formula_conflicts", force: :cascade do |t|
    t.integer  "formula_id",  null: false
    t.integer  "conflict_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "homebrew_formula_conflicts", ["formula_id", "conflict_id"], name: "homebrew_formula_conflicts_uniqueness", unique: true, using: :btree

  create_table "homebrew_formula_dependencies", force: :cascade do |t|
    t.integer  "formula_id",    null: false
    t.integer  "dependency_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "homebrew_formula_dependencies", ["formula_id", "dependency_id"], name: "homebrew_formula_dependencies_uniqueness", unique: true, using: :btree

  create_table "homebrew_formulas", force: :cascade do |t|
    t.string   "name",                                  null: false
    t.string   "version"
    t.string   "homepage"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "touched_on"
    t.string   "filename",                              null: false
    t.boolean  "description_automatic", default: false
    t.boolean  "external",              default: false, null: false
  end

  add_index "homebrew_formulas", ["external"], name: "index_homebrew_formulas_on_external", using: :btree
  add_index "homebrew_formulas", ["filename"], name: "index_homebrew_formulas_on_filename", using: :btree

  create_table "imports", force: :cascade do |t|
    t.boolean  "success"
    t.text     "message"
    t.datetime "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imports", ["created_at"], name: "index_imports_on_created_at", order: {"created_at"=>:desc}, using: :btree

end
