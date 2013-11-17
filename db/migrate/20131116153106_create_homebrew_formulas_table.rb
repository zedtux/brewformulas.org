class CreateHomebrewFormulasTable < ActiveRecord::Migration
  def change
    create_table :homebrew_formulas do |t|
      t.string   :name, :null => false
      t.string   :version
      t.string   :homepage
      t.text     :description
      t.timestamps
    end
  end
end
