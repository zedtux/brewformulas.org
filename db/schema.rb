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

ActiveRecord::Schema.define(version: 20170601090528) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "homebrew_formula_conflicts", force: :cascade do |t|
    t.integer "formula_id", null: false
    t.integer "conflict_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["formula_id", "conflict_id"], name: "homebrew_formula_conflicts_uniqueness", unique: true
  end

  create_table "homebrew_formula_dependencies", force: :cascade do |t|
    t.integer "formula_id", null: false
    t.integer "dependency_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["formula_id", "dependency_id"], name: "homebrew_formula_dependencies_uniqueness", unique: true
  end

  create_table "homebrew_formulas", force: :cascade do |t|
    t.string "name", null: false
    t.string "version"
    t.string "homepage"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "touched_on"
    t.string "filename", null: false
    t.boolean "description_automatic", default: false
    t.boolean "external", default: false, null: false
    t.string "yearly_hits", null: false
    t.index ["external"], name: "index_homebrew_formulas_on_external"
    t.index ["filename"], name: "index_homebrew_formulas_on_filename"
  end

  create_table "imports", force: :cascade do |t|
    t.boolean "success"
    t.text "message"
    t.datetime "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["created_at"], name: "index_imports_on_created_at", order: { created_at: :desc }
  end

  create_table "punches", id: :serial, force: :cascade do |t|
    t.integer "punchable_id", null: false
    t.string "punchable_type", limit: 20, null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "average_time", null: false
    t.integer "hits", default: 1, null: false
    t.string "year_and_month", null: false
    t.index ["average_time"], name: "index_punches_on_average_time"
    t.index ["punchable_type", "punchable_id"], name: "punchable_index"
    t.index ["year_and_month"], name: "index_punches_on_year_and_month"
  end

end
