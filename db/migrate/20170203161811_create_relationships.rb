class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :household_id, null: false
      t.integer :predecessor_id, null: false
      t.integer :successor_id, null: false
      t.string :relationship, null: false

      t.timestamps null: false
    end
  end
end
