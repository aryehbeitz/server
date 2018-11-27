class RegistrationsController < Devise::RegistrationsController
	respond_to :html, :json

  prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]
  before_action :configure_permitted_parameters


  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        render json: { success: true, user: resource, redirect_url: after_sign_up_path_for(user_attributes[:type]) }
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        render json: { success: false, errors: @resource.errors }
      end
    else
      status = 400
      user = User.where(email: resource.email).first
      user ||= User.where(phone: resource.phone).first
      clean_up_passwords resource
      set_minimum_password_length
      error_json = {
          errors: resource.errors
      }
      if user
        error_json[:user_url] = user_url(user)
        status = 303
      end
      render json: error_json , status: status
    end
  end

  def update

  end

  protected

  def user_attributes
    params[:user]
  end

  def after_sign_up_path_for(type)
  	new_salon_url if type == 'host'
		#polymorphic_path(resource, locale: nil) if user_attributes[:type] == 'manager'
  end


  def after_inactive_sign_up_path_for
    new_salon_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :phone])
  end

end