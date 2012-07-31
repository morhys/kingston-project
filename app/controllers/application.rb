# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_kingston_cs'
  #session :disabled => true
  
  private #------------
	
	def authorize_access
	  if !session[:user_id]
	    flash[:notice] = "Please log in."
	    redirect_to(:controller => 'staff', :action => 'login')
	    return false
	  end	
	end
	
end
