# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  require 'facebooker'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  attr_accessor :current_user
  before_filter :facebook_setup?
  helper_attr :current_user
  
 ##########
 # Facebook
 ##########
  def facebook_setup?
    if request_comes_from_facebook?
        ensure_authenticated_to_facebook 
        set_current_user
    end
  end  
 
  def create_user 
     self.current_user = User.for(facebook_session.user.to_i, facebook_session)
  end

  def set_current_user 
     self.current_user = User.for(facebook_session.user.to_i, facebook_session)
  end
   
 ##########
 # AuthLogic
 ########## 
  
  def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

     private
       def current_user_session
         return @current_user_session if defined?(@current_user_session)
         @current_user_session = UserSession.find
       end

       def current_user
         return @current_user if defined?(@current_user)
         @current_user = current_user_session && current_user_session.user
       end
       
       
   
 
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
