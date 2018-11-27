class WitnessYearsController < ApplicationController
  before_action :set_witness_year, only: [:index, :show, :edit, :update, :destroy]

  # GET /witness_years
  # GET /witness_years.json
  def index
    @witness_years = WitnessYear.all
  end

  # GET /witness_years/1
  # GET /witness_years/1.json
  def show
    @countries = CountryRegionCity.get_cities_by_country
  end

  # GET /witness_years/new
  def new
    @witness_year = WitnessYear.new
  end

  # GET /witness_years/1/edit
  def edit
  end

  # POST /witness_years
  # POST /witness_years.json
  def create
    @witness_year = WitnessYear.new(witness_year_params)

    respond_to do |format|
      if @witness_year.save
        format.html { redirect_to @witness_year, notice: 'Witness year was successfully created.' }
        format.json { render :show, status: :created, location: @witness_year }
      else
        format.html { render :new }
        format.json { render json: @witness_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /witness_years/1
  # PATCH/PUT /witness_years/1.json
  def update
    respond_to do |format|
      if @witness_year.update(witness_year_params)
        format.html { redirect_to @witness_year, notice: 'Witness year was successfully updated.' }
        format.json { render :show, status: :ok, location: @witness_year }
      else
        format.html { render :edit }
        format.json { render json: @witness_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /witness_years/1
  # DELETE /witness_years/1.json
  def destroy
    @witness_year.destroy
    respond_to do |format|
      format.html { redirect_to witness_years_url, notice: 'Witness year was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_witness_year
      @witness_year = WitnessYear.where(witness_id: params[:witness_id], year: Year.current_year).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def witness_year_params
      params.require(:witness_year).permit(:Phoned)
    end
end
