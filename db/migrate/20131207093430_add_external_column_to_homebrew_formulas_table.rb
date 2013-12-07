class AddExternalColumnToHomebrewFormulasTable < ActiveRecord::Migration
  def change
    add_column :homebrew_formulas, :external, :boolean, default: false, null: false
    add_index :homebrew_formulas, :external
  end
end
