class WitnessSalonsController < ApplicationController
  before_action :set_witness_salon, only: [:show, :edit, :update, :destroy]

  # GET /witness_salons
  # GET /witness_salons.json
  def index
    @witness_salons = WitnessSalon.all
  end

  # GET /witness_salons/1
  # GET /witness_salons/1.json
  def show
  end

  # GET /witness_salons/new
  def new
    @witness_salon = WitnessSalon.new
  end

  # GET /witness_salons/1/edit
  def edit
  end

  # POST /witness_salons
  # POST /witness_salons.json
  def create
    @witness_salon = WitnessSalon.new(witness_salon_params)

    respond_to do |format|
      if @witness_salon.save
        format.html { redirect_to @witness_salon, notice: 'Witness salon was successfully created.' }
        format.json { render :show, status: :created, location: @witness_salon }
      else
        format.html { render :new }
        format.json { render json: @witness_salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /witness_salons/1
  # PATCH/PUT /witness_salons/1.json
  def update
    respond_to do |format|
      if @witness_salon.update(witness_salon_params)
        format.html { redirect_to @witness_salon, notice: 'Witness salon was successfully updated.' }
        format.json { render :show, status: :ok, location: @witness_salon }
      else
        format.html { render :edit }
        format.json { render json: @witness_salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /witness_salons/1
  # DELETE /witness_salons/1.json
  def destroy
    @witness_salon.destroy
    respond_to do |format|
      format.html { redirect_to witness_salons_url, notice: 'Witness salon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_witness_salon
      @witness_salon = WitnessSalon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def witness_salon_params
      params.require(:witness_salon).permit(:first_contactd)
    end
end
