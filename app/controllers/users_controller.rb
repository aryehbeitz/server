class UsersController < ApplicationController
	before_action :authenticate_user!, only: [:show, :assignrole, :profile]
	before_action :set_user, only: [:show, :assignrole, :profile]
	before_action :check_permission!, only: [:show, :edit, :update, :destroy]

	def check_permission!
		render :file => "public/404.html", :status => :not_found unless current_user.staff? or @user == current_user
	end

	def new
		@type = params[:type]
	end

	def show
		@user_salons = @user.user_salon.all
		@salons = @user.salon.all
	end

	def assignrole
		if !params[:changerole].nil?
			user_role = RoleChanger.new(params[:id])
			if params[:changerole] == true
				user_role.change_role
				user_role.activate_user
			else
				user_role.activate_user
				user_role.activate_role
			end
			render json: user_role.reload_user, status: 201
		end

	end

	def profile
		if current_user.nil? || current_user.meta.nil?
			redirect_to user_session_path
		else
			redirect_to polymorphic_path(current_user.meta)
		end
	end

	def set_user
		@user = User.where(id: params[:id]).first
		render :file => "public/404.html", :status => :not_found if @user.nil?
	end
	
end
