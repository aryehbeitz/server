class AddPlaceIdToCountryRegionCity < ActiveRecord::Migration[5.2]
  def change
    add_column :country_region_cities, :place_id, :string
  end
end
