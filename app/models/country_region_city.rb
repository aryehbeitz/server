class CountryRegionCity < ApplicationRecord

  def self.get_ids_by_country(country_id)
    CountryRegionCity.where(country_numcode: country_id).pluck(:id)
  end

  def self.get_all_with_staff
    self.get_all(true)
  end

  def self.get_all(include_staff=false)
    countries = CountryRegionCity.select(:country_name, :country_iso, :country_printable_name, :country_iso3, :country_numcode).distinct

    all = []
    countries.each do |c|
      country_json = {
          country_name: c.country_name,
          country_iso: c.country_iso,
          country_printable_name: c.country_printable_name,
          country_iso3: c.country_iso3,
          country_numcode: c.country_numcode,
          regions:[]
      }
      country_json[:staff] = Staff.get_managers_json('country', c.country_numcode) if include_staff

      regions = CountryRegionCity.select(:region_id, :region_name).where(country_numcode: c.country_numcode).distinct

      regions.each do |r|
        region_json = {
            region_id: r.region_id,
            region_name: r.region_name,
            cities: []
        }
        region_json[:staff] = Staff.get_managers_json('region', r.region_id) if include_staff

        cities = CountryRegionCity.select(:city_name_en, :city_name_he, :id).where(country_numcode: c.country_numcode, region_id: r.region_id)

        cities.each do |c|
          city_json = {
              #city_name: c.city_name,
              city_name_en: c.city_name_en,
              city_name_he: c.city_name_he,
              city_id: c.id
          }
          city_json[:staff] = Staff.get_managers_json('city', c.id) if include_staff

          region_json[:cities].append(city_json)
        end

        region_json[:cites_without_staff] = (region_json[:cities].select {|city| city[:staff].empty?} ) if include_staff
        country_json[:regions].append(region_json)
      end

      all.append(country_json)
    end

    return all

  end

  def self.get_cities_by_country
    countries = CountryRegionCity.select(:country_name, :country_iso, :country_printable_name, :country_iso3, :country_numcode).distinct

    all = []
    countries.each do |c|
      country_json = {
          country_name: c.country_name,
          country_iso: c.country_iso,
          country_printable_name: c.country_printable_name,
          country_iso3: c.country_iso3,
          country_numcode: c.country_numcode,
          cities:[]
      }

      cities = CountryRegionCity.select(:city_name_en, :city_name_he, :id).where(country_numcode: c.country_numcode)

      cities.each do |c|
        city_json = {
            city_name_en: c.city_name_en,
            city_name_he: c.city_name_he,
            city_id: c.id
        }
        country_json[:cities].append(city_json)
      end

      all.append(country_json)
    end

    return all


  end
end
