class CreateHouseholdMembers < ActiveRecord::Migration
  def change
    create_table :household_members do |t|

      t.timestamps null: false
    end
  end
end
