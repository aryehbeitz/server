class WitnessesController < ApplicationController
  before_action :set_witness, only: [:show, :edit, :update, :destroy, :assign]
  before_action :is_staff

  # GET /witnesses
  # GET /witnesses.json
  def index
    @witnesses = Witness.all
  end

  # GET /witnesses/1
  # GET /witnesses/1.json
  def show
  end

  # GET /witnesses/new
  def new
    @witness = Witness.new
    @countries = CountryRegionCity.get_cities_by_country
  end

  # GET /witnesses/1/edit
  def edit
  end

  # POST /witnesses
  # POST /witnesses.json
  def create
    user_params = params[:witness][:user]
    user = User.find(user_params[:id])
    @witness = Witness.where(user_id: user.id).first
    if @witness
      respond_to do |format|
        format.html { redirect_to @witness, notice: 'Witness found.' }
        format.json { render :show, status: :created, location: @witness }
      end
      return
    end

    @witness = Witness.new(witness_params)
    puts @witness.to_json
    @witness[:user_id] = user.id
    @witness[:country_region_city_id] = params[:witness][:country_region_city][:city_id]

    puts @witness.to_json

    respond_to do |format|
      if @witness.save
        format.html { redirect_to @witness, notice: 'Witness was successfully created.' }
        format.json { render :show, status: :created, location: @witness }
      else
        format.html { render :new }
        format.json { render json: @witness.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /witnesses/1
  # PATCH/PUT /witnesses/1.json
  def update
    respond_to do |format|
      if @witness.update(witness_params)
        format.html { redirect_to @witness, notice: 'Witness was successfully updated.' }
        format.json { render :show, status: :ok, location: @witness }
      else
        format.html { render :edit }
        format.json { render json: @witness.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /witnesses/1
  # DELETE /witnesses/1.json
  def destroy
    @witness.destroy
    respond_to do |format|
      format.html { redirect_to witnesses_url, notice: 'Witness was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /witnesses/1/assign
  def assign
    @salons = Salon.all
  end

  def unassign
    @witness = Witness.find(params[:id])
    @host_id = @witness.host_id
    @host = @witness.host
    @witness.update_attributes(host_id: nil, host:nil)
    @host.update_column(:assignment_time, nil)
    #ManagerMailer.assignment_cancelled(@host_id, @witness.id, current_user).deliver
    redirect_to @witness
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_witness
      @witness = Witness.find(params[:id])
      redirect_to witnesses_url if @witness.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def witness_params
      params.require(:witness).permit(:address, :can_morning, :can_afternoon, :can_evening, :free_on_day, :special_population,
                                      :available_day1, :available_day2, :available_day3, :available_day4, :available_day5, :available_day6,
                                      :available_day7, :contact_name, :witness_type, :language, :contact_phone, :stairs)
    end
end
