class CountryRegionCitiesController < ApplicationController
  before_action :set_country_region_city, only: [:show, :edit, :update, :destroy]

  # GET /country_region_cities
  # GET /country_region_cities.json
  def index
    @country_region_cities = CountryRegionCity.all
  end

  # GET /country_region_cities/1
  # GET /country_region_cities/1.json
  def show
  end

  # GET /country_region_cities/new
  def new
    @country_region_city = CountryRegionCity.new
  end

  # GET /country_region_cities/1/edit
  def edit
  end

  # POST /country_region_cities
  # POST /country_region_cities.json
  def create
    @country_region_city = CountryRegionCity.new(country_region_city_params)

    respond_to do |format|
      if @country_region_city.save
        format.html { redirect_to @country_region_city, notice: 'Country region city was successfully created.' }
        format.json { render :show, status: :created, location: @country_region_city }
      else
        format.html { render :new }
        format.json { render json: @country_region_city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /country_region_cities/1
  # PATCH/PUT /country_region_cities/1.json
  def update
    respond_to do |format|
      if @country_region_city.update(country_region_city_params)
        format.html { redirect_to @country_region_city, notice: 'Country region city was successfully updated.' }
        format.json { render :show, status: :ok, location: @country_region_city }
      else
        format.html { render :edit }
        format.json { render json: @country_region_city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /country_region_cities/1
  # DELETE /country_region_cities/1.json
  def destroy
    @country_region_city.destroy
    respond_to do |format|
      format.html { redirect_to country_region_cities_url, notice: 'Country region city was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country_region_city
      @country_region_city = CountryRegionCity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_region_city_params
      params.require(:country_region_city).permit(:country_name, :country_iso, :country_printable_name, :country_iso3, :country_numcode, :region_name, :region_id, :city_name_en, :city_name_he)
    end
end
