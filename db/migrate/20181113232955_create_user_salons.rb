class CreateUserSalons < ActiveRecord::Migration[5.2]
  def change
    create_table :user_salons do |t|
      t.integer :user_id
      t.integer :salon_id
      t.integer :guest_amount
      t.boolean :approved
      t.boolean :canceled
      t.integer :year

      t.timestamps
    end
  end
end
