class AddCityNameToCountryRegionCity < ActiveRecord::Migration[5.2]
  def change
    add_column :country_region_cities, :city_name, :string
  end
end
