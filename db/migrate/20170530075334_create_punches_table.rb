class CreatePunchesTable < ActiveRecord::Migration[4.2]
  def self.up
    create_table :punches do |t|
      t.integer :punchable_id, null: false
      t.string :punchable_type, null: false, limit: 20
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.datetime :average_time, null: false
      t.integer :hits, null: false, default: 1
      t.string :year_and_month, null: false
    end
    add_index :punches, [:punchable_type, :punchable_id], name: :punchable_index, unique: false
    add_index :punches, :average_time, unique: false
    add_index :punches, :year_and_month, unique: false
  end

  def self.down
    remove_index :punches, name: :punchable_index
    remove_index :punches, :average_time
    remove_index :punches, :year_and_month
    drop_table :punches
  end
end
