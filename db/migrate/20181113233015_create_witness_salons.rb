class CreateWitnessSalons < ActiveRecord::Migration[5.2]
  def change
    create_table :witness_salons do |t|
      t.integer :salon
      t.integer :user_id
      t.boolean :first_contactd

      t.timestamps
    end
  end
end
