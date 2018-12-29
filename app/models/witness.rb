class Witness < ApplicationRecord
  belongs_to :user
  belongs_to :country_region_city, optional: true
  has_many :salon
  has_one :witness_year, ->{ where('year = ?', Year.current_year)}


  def direct_manager_json
    Staff.get_managers_json('witness',self.id)
  end

  def comments
    Comment.get_all_json(self.id, 'witnesses')
  end

  def self.witness_params(params)
    params.require(:witness).permit(:address, :can_morning, :can_afternoon, :can_evening, :free_on_day, :special_population,
                                    :contact_name, :witness_type, :language, :contact_phone, :stairs, :wheelchair, :hearing_impairment,
                                    :visual_impairment)
  end
end
