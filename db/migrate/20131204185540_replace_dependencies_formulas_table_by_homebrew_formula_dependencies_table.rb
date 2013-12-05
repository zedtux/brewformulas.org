class ReplaceDependenciesFormulasTableByHomebrewFormulaDependenciesTable < ActiveRecord::Migration
  def change
    drop_table :dependencies_formulas

    create_table :homebrew_formula_dependencies do |t|
      t.integer  :formula_id, null: false
      t.integer  :dependency_id, null: false
      t.timestamps
    end
    add_index :homebrew_formula_dependencies,
      [:formula_id, :dependency_id],
      unique: true,
      name: "homebrew_formula_dependencies_uniqueness"
  end
end
