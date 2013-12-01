class CreateHomebrewFormulasFormulasTable < ActiveRecord::Migration
  def change
    create_table :dependencies_formulas, id: false do |t|
      t.references :dependency
      t.references :formula
    end
    add_index :dependencies_formulas, [:dependency_id, :formula_id], unique: true
  end
end
