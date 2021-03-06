class PagesController < ApplicationController
  #include PagesHelper
  #include CitiesHelper
  include ApplicationHelper

  respond_to :html, :json


#TODO add here where users are active this year
  def home

    # get region id
    region_id = params[:region_id] ? params[:region_id] : ""

    # get country_id
    country_id = params[:country_id]

    #@cities = City
    #if !country_id.present? && !region_id.present?
    #  @cities = @cities.all
    #else
    #  @cities = filter_cities(@cities, country_id, region_id)
    #  @cities = @cities.sort_alphabetical_by{ |c| c[:name] }
    #end
    # get city ids
    #city_ids = nil
    #if region_id.present?
    #  city_ids = @cities.map {|c| c[:id] }
    #end

    @salons = Salon.includes(:user, :country_region_city, :user_salon)#.where(host_conditions_hash)
    @salons = @salons.where.not(user_id: current_user.id) if !current_user.nil?

    @salons = @salons.where(country_region_city_id: CountryRegionCity.get_ids_by_country(country_id)) if !country_id.nil?

    # additional filtering
    #@hosts = @hosts.where('invites_confirmed_count + invites_pending_count < max_guests')
    @salons = filter_by_query(@salons, query)
    @salons = filter_by_language(@salons, 'event_language', params[:event_language])
    @salons = @salons.paginate(:page => params[:page] || 1, :per_page => 10)
    @total_items = @salons.count

    @salons = sort_by_field(@salons, params[:sort] || 'user.full_name')
    if params[:reverse_ordering].to_i == 0
      @salons = @salons.reverse
    end

    @countries = CountryRegionCity.get_all

    respond_to do |format|
      format.html
      format.json { render json: {
          salons: @salons.to_json(
              :include => [{ :user => { :methods => [:first_name] } }, ], #:city, :country],
              :methods => [:available_places, :converted_time]
          ),
          total_items: @total_items,
          page: params[:page] || 1
      }
      }
    end
  end

  def host_register_link
    @host = Host.find(params[:id])
  end

  def welcome
  end

  private
  def host_conditions_hash
    h = { }
    h[:strangers] = true
    h[:active] = true
    h[:city_id] = params[:city_ids] if !params[:city_ids].blank?
    h[:max_guests] = 1..9999
    h[:received_registration_mail] = true
    h[:country_id] = params[:country_id] if !params[:country_id].blank?
    h[:event_date] = Date.parse(params[:event_date]) if !params[:event_date].blank?
    h
  end

  def query
    params[:query]
  end


  def host_in_vetrans(h, vetrans)
    return true if !vetrans
    h.has_witness && h.witness.try(:is_vetran)
  end

  def sort_by_field(hosts, field)
    case field
      when 'user.full_name'
        return hosts.sort_alphabetical_by{ |h| h.try(:user).try(:full_name) }
      when 'city'
        return hosts.sort_by! { |h| h.city.try(:name).to_s }
      when 'address'
        return hosts.sort_by! { |h| h.try(:address).to_s }
      when 'event_date'
        return hosts.sort_by! { |h| h.try(:event_date).to_s }
      when 'event_language'
        return hosts.sort_by! { |h| h.try(:event_language).to_s }
      when 'available_places'
        return hosts.sort_by! { |h| h.try(:available_places).to_s }
      else
        return hosts
    end
  end
end
