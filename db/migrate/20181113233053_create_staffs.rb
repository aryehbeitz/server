class CreateStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :staffs do |t|
      t.integer :user_id
      t.string :entity_type
      t.integer :entity_id

      t.timestamps
    end
  end
end
