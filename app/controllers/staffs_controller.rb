class StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :update, :destroy]
  before_action :is_staff
  before_action :is_admin, only: [:index, :destroy, :update, :new_staff_page, :new_staff]

  def is_admin
    redirect_to root_path unless current_user && (current_user.admin?)
  end

  # GET /new_staff
  def new_staff_page
    #@countries = CountryRegionCity.get_all_with_staff
  end

  # POST /new_staff.json
  def new_staff
    user_params = params.require(:user).permit(:email, :phone, :full_name)
    user = User.exist?(user_params[:email], user_params[:phone])
    user ||= Staff.create(user_params[:email], user_params[:phone], user_params[:full_name], 0)

    if Staff.where(user_id: user.id).count == 0
      Staff.new(user_id: user.id, entity_type: "new").save!
      render json: {result: "OK"}
    else
      render json: {result: "exist"}
    end


  end



  # GET /staffs
  # GET /staffs.json
  def index
    @staffs = Staff.all
    @countries = CountryRegionCity.get_all_with_staff
  end

  # GET /staffs/1
  # GET /staffs/1.json
  def show
    @salons = Staff.salons(current_user).includes(:user, :country_region_city)
    @witnesses = Staff.witness(current_user).includes(:user, :country_region_city, :witness_year)

    if params[:filter]
      if params[:filter][:direct_manager] == "true"
        @witnesses = Staff.direct_manager_witness(current_user).includes(:user, :country_region_city, :witness_year)
      end

      @witnesses = @witnesses.where(witness_filter) if witness_filter

      if not params[:country_numcode].empty?
        country_region_city_ids = CountryRegionCity.get_ids_by_country(params[:country_numcode])
        @witnesses = @witnesses.where(country_region_city_id: country_region_city_ids)
      end

      @witnesses = @witnesses.joins(:salon) if params[:filter][:has_host] == "true"
      @witnesses = @witnesses.left_outer_joins(:salon).where('salons.id IS NULL') if params[:filter][:has_host] == "false"

      @witnesses = @witnesses.joins(:witness_year).where(witness_year_filter) if witness_year_filter

      @witnesses = @witnesses.left_outer_joins(:witness_year).where('witness_years.id IS NULL') if params[:filter][:required_witness_year] == "true"
    end

    @total_witnesses = @witnesses.count
    @witnesses = @witnesses.paginate(:page => params[:page] || 1, :per_page => 10)
  end

  def witness_filter
    filter = params[:filter].try(:[], :witness)
    filter.permit(:witness_type, :stairs, :special_population, :language, :country_region_city_id) if filter
  end

  def witness_year_filter
    filter = params[:filter].try(:[], :witness_year)
    filter.permit(:available_day1, :available_day2, :available_day3, :available_day4, :available_day5, :available_day6,
                  :available_day7) if filter
  end

  # POST /staffs
  # POST /staffs.json
  def create
    if !Staff.is_manager_of_entity(current_user, params[:staff][:entity_type], params[:staff][:entity_id])
      head :forbidden
      return
    end

    if params[:staff][:email]
      user = User.where(email: params[:staff][:email]).first
      user = user || Staff.create(email: params[:staff][:email]).user
      params[:staff][:user_id] = user.id
    end

    @staff = Staff.new(staff_params)

    respond_to do |format|
      if @staff.save
        format.html { redirect_to @staff, notice: 'Staff was successfully created.' }
        format.json { render :show, status: :created, location: @staff }
      else
        format.html { render :new }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staffs/1
  # PATCH/PUT /staffs/1.json
  def update
    respond_to do |format|
      if @staff.update(staff_params)
        format.html { redirect_to @staff, notice: 'Staff was successfully updated.' }
        format.json { render :show, status: :ok, location: @staff }
      else
        format.html { render :edit }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staffs/1
  # DELETE /staffs/1.json
  def destroy
    Staff.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to staffs_url, notice: 'Staff was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff
      @staff = Staff.where(user_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_params
      params.require(:staff).permit(:user_id, :entity_type, :entity_id)
    end
end
