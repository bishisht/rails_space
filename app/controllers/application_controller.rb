class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_authorization

  # Pick a unique cookie name to distinguish our session data from others'
  # session :session_key => '_rails_space_session_id'
  # Check for a valid authorization cookie, possibly logging the user in.
  def check_authorization
    authorization_token = cookies[:authorization_token]
    # if cookies[:authorization_token] and not session[:user_id]
    if authorization_token and not logged_in?
        user=User.find_by_authorization_token(cookies[:authorization_token])
        # if user
        user.login?(session) if user
            # session[:user_id]=user.id
        # end
    end
  end
end
