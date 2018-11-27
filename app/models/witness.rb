class Witness < ApplicationRecord
  belongs_to :user
  belongs_to :country_region_city, optional: true
  has_many :salon
  has_many :witness_year, ->{ where('year = ?', Year.current_year)}


  def direct_manager_json
    Staff.get_managers_json('witness',self.id)
  end
end
