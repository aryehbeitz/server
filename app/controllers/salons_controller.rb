class SalonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_salon, only: [:show, :edit, :update, :destroy]
  before_action :check_permission!, only: [:show, :edit, :update, :destroy]

  def check_permission!
    render :file => "public/404.html", :status => :not_found unless current_user.staff? or @salon.user == current_user
  end

  def salon_params
    params.require(:salon).permit(:org_id, :address, :country_region_city_id, :floor, :elevator, :event_date, :event_time,
    :event_language, :survivor_needed, :strangers, :max_guests, :public_text, :inside_text, :witness_id)
  end

  # GET /salons
  # GET /salons.json
  def index
    #@salons = Salon.where(year: @year).join(&User_Salon).join(&Witness_Salon)
  end

  # GET /salons/1
  # GET /salons/1.json
  def show
  end

  # GET /salons/new
  def new
    @salon = Salon.new
    @salon.user_id = current_user.id
    @salon.save
    @countries = CountryRegionCity.get_cities_by_country
    HostMailer.new_host(@salon, I18n.locale).deliver
  end

  # GET /salons/1/edit
  def edit
  end

  # POST /salons
  # POST /salons.json
  def create
    @salon = Salon.new(salon_params)

    respond_to do |format|
      if @salon.save
        format.html { redirect_to @salon, notice: 'Salon was successfully created.' }
        format.json { render :show, status: :created, location: @salon }
      else
        format.html { render :new }
        format.json { render json: @salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /salons/1
  # PATCH/PUT /salons/1.json
  def update
    respond_to do |format|
      if @salon.update(salon_params)
        format.html { redirect_to @salon, notice: 'Salon was successfully updated.' }
        format.json { render :show, status: :ok, location: @salon }
      else
        format.html { render :edit }
        format.json { render json: @salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /salons/1
  # DELETE /salons/1.json
  def destroy
    @salon.destroy
    respond_to do |format|
      format.html { redirect_to salons_url, notice: 'Salon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or cons traints between actions.
    def set_salon
      @salon = Salon.where(id: params[:id]).first
      render :file => "public/404.html", :status => :not_found if @salon.nil?
    end
end
