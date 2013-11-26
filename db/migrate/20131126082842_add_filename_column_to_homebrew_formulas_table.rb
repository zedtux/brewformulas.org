class AddFilenameColumnToHomebrewFormulasTable < ActiveRecord::Migration
  def change
    # We are going to use the filename as primary key
    # so we can remove all and redo the import
    Homebrew::Formula.destroy_all

    add_column :homebrew_formulas, :filename, :string, null: false
    add_index :homebrew_formulas, :filename
  end
end
