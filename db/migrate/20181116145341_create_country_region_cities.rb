class CreateCountryRegionCities < ActiveRecord::Migration[5.2]
  def change
    create_table :country_region_cities do |t|
      t.string :country_name
      t.string :country_iso
      t.string :country_printable_name
      t.string :country_iso3
      t.integer :country_numcode
      t.string :region_name
      t.integer :region_id
      t.string :city_name_en
      t.string :city_name_he

      t.timestamps
    end
  end

  #add_index :country_region_cities, [:country_iso3, :region_id], unique: true, name: :country_region_uniq
  #add_index :country_region_cities, [:country_iso3, :region_id, :country_region_cities_id], unique: true, name: :country_region_city_uniq

end
