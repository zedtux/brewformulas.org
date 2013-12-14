class CreateHomebrewFormulaConflictsTable < ActiveRecord::Migration
  def change
    create_table :homebrew_formula_conflicts do |t|
      t.integer  :formula_id, null: false
      t.integer  :conflict_id, null: false
      t.timestamps
    end
    add_index :homebrew_formula_conflicts,
              [:formula_id, :conflict_id],
              unique: true,
              name: 'homebrew_formula_conflicts_uniqueness'
  end
end
