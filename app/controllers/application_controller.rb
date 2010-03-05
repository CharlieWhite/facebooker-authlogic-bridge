# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :fb_sig_friends, :password, :password_confirmation
 
  helper_method :facebook_session, :current_user_session, :current_user
 
  layout "default"
 
  attr_accessor :current_user 
  helper_attr :current_user
  
  before_filter :check_if_fb_app_installed?
  
  
  def current_user_session
          return @current_user_session if defined?(@current_user_session)
          @current_user_session = UserSession.find
   end

  def current_user
          return @current_user if defined?(@current_user)
          @current_user = (current_user_session && current_user_session.user) ||login_from_fb_connect ||  login_from_fb
  end
  
  def login_from_fb_connect
    if set_facebook_session
      self.current_user = User.for(facebook_session.user.to_i, facebook_session)
    end 
  end
  
  def login_from_fb
    if request_comes_from_facebook?
     if ensure_authenticated_to_facebook 
       self.current_user = User.for(facebook_session.user.to_i, facebook_session)
     end
    end
  end
  
  def check_if_fb_app_installed?
    if request_comes_from_facebook?
      ensure_application_is_installed_by_facebook_user
    end
  end
  
  
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
  
end
