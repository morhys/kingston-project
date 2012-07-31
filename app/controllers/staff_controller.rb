class StaffController < ApplicationController

  layout "staff"

  before_filter :authorize_access, :except => [:index, :login, :send_login]
  
  def index
    login
    render(:action => 'Menu')
  end

  def login
    #@user = User.new
  end
  
  def send_login
		found_user = User.authenticate(params[:username], params[:password])
		if found_user
			session[:user_id] = found_user.id
			flash[:notice] = "You are now logged in."
			redirect_to(:action => 'menu')
		else
			flash.now[:notice] = "Username/password combination incorrect. Please make sure your caps lock key is off and try again."
			render(:action => 'login')
		end
  end

  def menu
    # just text
  end

  def logout
		session[:user_id] = nil
		flash[:notice] = "You are now logged out."
		redirect_to(:action => 'login')
  end
end
