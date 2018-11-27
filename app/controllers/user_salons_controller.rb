class UserSalonsController < ApplicationController
  before_action :set_user_salon, only: [:show, :edit, :update, :destroy]

  # GET /user_salons
  # GET /user_salons.json
  def index
    @user_salons = UserSalon.all
  end

  # GET /user_salons/1
  # GET /user_salons/1.json
  def show
  end

  # GET /user_salons/new
  def new
    @user_salon = UserSalon.new
  end

  # GET /user_salons/1/edit
  def edit
  end

  # POST /user_salons
  # POST /user_salons.json
  def create
    @user_salon = UserSalon.new(user_salon_params)

    @user_salon.user_id = current_user.id

    respond_to do |format|
      if @user_salon.save
        format.html { render json: @user_salon, notice: 'User salon was successfully created.' }
        format.json { render status: :created }
      else
        format.html { render :new }
        format.json { render json: @user_salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_salons/1
  # PATCH/PUT /user_salons/1.json
  def update
    respond_to do |format|
      if @user_salon.update(user_salon_params)
        format.html { redirect_to @user_salon, notice: 'User salon was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_salon }
      else
        format.html { render :edit }
        format.json { render json: @user_salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_salons/1
  # DELETE /user_salons/1.json
  def destroy
    @user_salon.destroy
    respond_to do |format|
      format.html { redirect_to user_salons_url, notice: 'User salon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_salon
      @user_salon = UserSalon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_salon_params
      params.require(:user_salon).permit(:salon_id, :guest_amount, :approved)
    end
end
