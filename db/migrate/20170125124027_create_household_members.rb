class CreateHouseholdMembers < ActiveRecord::Migration
  def change
    create_table :household_members do |t|
      t.integer :household_id, null: false
      t.string :name, null: false, limit: 255
      t.boolean :is_primary, null: false, default: false
      t.text :successors
      t.timestamps null: false
    end
  end
end
