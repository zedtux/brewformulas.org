class AddsYearHitsColumnToTheHomebrewFormulasTable < ActiveRecord::Migration[5.1]
  def change
    add_column :homebrew_formulas, :yearly_hits, :string

    Homebrew::Formula.update_all(yearly_hits: [0,0,0,0,0,0,0,0,0,0,0])

    change_column_null :homebrew_formulas, :yearly_hits, false
  end
end
