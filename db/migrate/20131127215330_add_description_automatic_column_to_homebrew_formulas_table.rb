class AddDescriptionAutomaticColumnToHomebrewFormulasTable < ActiveRecord::Migration
  def change
    add_column :homebrew_formulas, :description_automatic, :boolean, default: false
  end
end
