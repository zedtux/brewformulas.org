class AddTouchedOnColumnToHomebrewFormulasTable < ActiveRecord::Migration
  def change
    add_column :homebrew_formulas, :touched_on, :date
    execute "UPDATE homebrew_formulas SET touched_on = #{Date.yesterday}"
  end
end
