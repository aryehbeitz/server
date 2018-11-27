class CreateWitnesses < ActiveRecord::Migration[5.2]
  def change
    create_table :witnesses do |t|
      t.integer :user_id
      t.integer  :country_region_city_id
      t.string :address

      t.boolean :special_population

      t.string :contact_name
      t.string :contact_phone

      t.string :witness_type
      t.string :language

      t.boolean :stairs

      t.timestamps
    end
  end
end
