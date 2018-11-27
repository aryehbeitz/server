class Staff < ApplicationRecord
  belongs_to :user

  def self.salons(current_user)
    if current_user.admin?
      Salon.all
    else
      countries = Staff.where(user_id: current_user.id, entity_type: 'country').pluck(:entity_id)
      region = Staff.where(user_id: current_user.id, entity_type: 'region').pluck(:entity_id)
      cites = Staff.where(user_id: current_user.id, entity_type: 'city').pluck(:entity_id)

      places = CountryRegionCity.where(country_numcode: countries).or(CountryRegionCity.where(region_id: region)).or(CountryRegionCity.where(id: cites)).pluck(:id)

      Salon.where(country_region_city_id: places)
      end
  end

  def self.witness(current_user)
    if current_user.admin?
      Witness.all
    else
      countries = Staff.where(user_id: current_user.id, entity_type: 'country').pluck(:entity_id)
      region = Staff.where(user_id: current_user.id, entity_type: 'region').pluck(:entity_id)
      cites = Staff.where(user_id: current_user.id, entity_type: 'city').pluck(:entity_id)

      places = CountryRegionCity.where(country_numcode: countries).or(CountryRegionCity.where(region_id: region)).or(CountryRegionCity.where(id: cites)).pluck(:id)

      Witness.where(country_region_city_id: places)
    end
  end

  def self.manage_salon?(current_user, salon)
    salons(current_user).pluck(:id).include?(salon)
  end

  def self.get_managers_json(entity_type, entity_id)
    staff = Staff.where(entity_type: entity_type, entity_id: entity_id).includes(:user)
    staff_list = []
    staff.each do |s|
      json = {
          user_id: s.user.id,
          name: s.user.full_name
      }
      staff_list.append(json)
    end

    return staff_list
  end
end
