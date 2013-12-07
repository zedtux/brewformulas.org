class CreateImportsTable < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.boolean  :success
      t.text     :message
      t.datetime :ended_at
      t.timestamps
    end
    add_index :imports, :created_at, order: {created_at: :desc}
  end
end
