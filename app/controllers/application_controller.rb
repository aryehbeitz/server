class ApplicationController < ActionController::Base

  #before_action :authenticate_user!
  #before_action protect_from_forgery prepend: true
  before_action :set_locale
  before_action :set_year
  before_action :set_fb_app
  respond_to :json, :html

  def set_locale
    I18n.locale = params[:locale]
    I18n.locale ||= request.headers['locale'] if request.headers['locale'].present?
    I18n.locale ||= request.cookies['locale']
    I18n.locale ||= :he
  end

  def set_year
    Year.set_current_year(params[:year] || 2019)
  end

  def set_fb_app
    @fb_app_id = ENV['FACEBOOK_APP_ID'] || '754373994725074'
  end

  def is_staff
    redirect_to root_path unless current_user && (current_user.staff?)
  end

  def default_url_options
    { locale: I18n.locale, year: Year.current_year }
  end

end
