class Salon < ApplicationRecord
  belongs_to :user

  has_many :user_salon
  belongs_to :country_region_city, optional: true

  belongs_to :witness, optional: true

  def self.get_c
    CountryRegionCity.all
  end

  def pending_guest
    user_salon.select(:full_name, :phone, :email, :guest_amount, :id).where(approved: nil).joins(:user)
  end

  def approved_guest
    user_salon.select(:full_name, :phone, :email, :guest_amount, :id).where(approved: true).joins(:user)
  end

  def available_places
    return 0 if max_guests.nil?
    return (max_guests - invites_count > 0) ? (max_guests - invites_count) : 0
  end

  def invites_count
    user_salon.where(canceled: [false, nil]).sum(:guest_amount)
  end

  def converted_time
    return nil if event_time.nil?

    begin
      zone = TZInfo::Country.get(country.iso).zone_names.first
      Time.parse(event_time).in_time_zone(zone).strftime("%H:%M")
    rescue
      #Time.parse(event_time).strftime("%H:%M")
      event_time
    end

  end

end
