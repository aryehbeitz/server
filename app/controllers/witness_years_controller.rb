class WitnessYearsController < ApplicationController
  before_action :set_witness
  before_action :is_staff

  # GET /witness_years/
  # GET /witness_years/1
  def new_or_edit
    @witness_year = WitnessYear.where(id: params[:witness_year_id], year: Year.current_year).first if params[:witness_year_id].present?
    @countries = CountryRegionCity.get_cities_by_country
  end

  # POST /1.json
  # POST /witness_years.json
  def create_or_update
    @witness_year = WitnessYear.where(id: params[:witness_year][:id], year: Year.current_year).first if params[:witness_year].present?
    @witness_year ||= WitnessYear.new(year: Year.current_year, witness: @witness, first_staff_contacted: true)

    @comment = Comment.new(entity_type: 'witnesses', entity_id: @witness.id, user: current_user)
    @comment.content = "פרטי השיחה: #{params[:call_details][:free_text]}"

    @comment.content = @comment.content + " אין תשובה - להתקשר שוב"if params[:call_details][:no_answer]
    @comment.content = @comment.content + " אין תשובה - מספר טלפון לא תקין" if params[:call_details][:phone_error]
    @comment.content = @comment.content + " לא מעוניין להתארח בעתיד" if params[:call_details][:archived]
    @comment.content = @comment.content + "לא מעוניין להתארח השנה" if params[:call_details][:not_relevant]

    if params[:call_details][:no_answer]
      @witness_year.first_staff_contacted = false
    end

    if params[:call_details][:phone_error] or params[:call_details][:archived]
      if params[:call_details][:phone_error]
        type = 'phone_error'
      else
        type = 'archived'
      end
      ManagerMailer.witness_contact_help(@witness, type).deliver
    end


    #send email

    @witness_year.update_attributes(witness_year_params) if params[:witness_year].present?

    begin
    ActiveRecord::Base.transaction do
      @witness_year.save!
      @witness.save!
      @comment.save!
    end
    rescue => e
      error = e
    end

    respond_to do |format|
      if error.nil?
        format.html { redirect_to @witness_year, notice: 'Witness year was successfully created.' }
        format.json { render json: {}, status: :created }
      else
        format.html { render :new }
        format.json { render json: {error: error, witness_year: @witness_year.errors, witness: @witness.errors, comment: @comment.errors}, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_witness
    @witness = Witness.find(params[:witness_id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def witness_year_params
      params.require(:witness_year).permit(:available_day1, :available_day2, :available_day3, :available_day4, :available_day5, :available_day6,
      :available_day7, :can_morning, :can_afternoon, :can_evening)
    end
end