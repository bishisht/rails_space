require 'digest/sha1'
class UserController < ApplicationController
  include ApplicationHelper

  #Protect pages
  before_filter :protect, :except => [ :login, :register ]

  # This is the user hub page.
  def index
    @title= "Rails Space User Hub"
    # This will be a protedted page for viewing user information.
  end

  
  def login
    # This action is used for logging in users.

    @title="Log in to RailsSpace"
    if request.get?
      @user=User.new(:remember_me => remember_me_string)
    # if request and params[:user]
    elsif param_posted?(:user)
      @user=User.new(user_params)
      user=User.find_by_screen_name_and_password(@user.screen_name, @user.password)
      if user
        session[:user_id]=user.id
        # user.login!(session)
        if @user.remember_me == "1"
          user.remember!(cookies)
          # # The box is checked, so set the remember_me cookie.
          # cookies[:remember_me] = { :value => "1",
          #                           :expires => 10.years.from_now }
          # # user.authorization_token = user.id
          # user.authorization_token = Digest::SHA1.hexdigest(
          #                             "#{user.screen_name}:
          #                             #{user.paassword}")
          # user.save!
          # cookies[:authorization_token] = {
          #   :value => user.authorization_token,
          #   :expires => 10.years.from_now }
        else
          user.forget!(cookies)
        end
        flash[:notice] = "User #{user.screen_name} logged in!"
        redirect_to_forwarding_url
        # if (redirect_url = session[:protected_page])
        #   session[:protected_page]=nil
        #   redirect_to redirect_url
        # else
        #   redirect_to :action => "index"
        # end
      else
        # Dont show the password again in the view.
        # @user.password=nil  
        @user.clear_password!
        flash[:notice] = "Invalid screen_name/password combination!"
      end
    end
  end

  # This action is used for logging out users.
  def logout
    # session[:user_id]=nil
    User.logout!(session,cookies)
    flash[:notice] ="Logged out!"
    redirect_to(:action => 'index', :controller => 'site')
  end

  def user_params
    params.require(:user).permit(:screen_name, :email, :password )
  end

  # This action is used for registering users.
  def register
  	@title="Register"
  	# if request.post? and params[:user]
    if param_posted?(:user)
  		@user=User.create(user_params)
  		if @user.save
        # session[:user_id]=@user.id
        @user.login!(session)
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to_forwarding_url
        # if (redirect_url = session[:protected_page])
        #   session[:protected_page] = nil
        #   redirect_to redirect_url
        # else
        #   redirect_to :action => 'index'
        # end  
      else
        @user.clear_password!
      end
  	end
  end

  # Private actions.

  private

  # Protect a page from unauthorized access.
  def protect
    unless logged_in?
    # user.login!(session)
      session[:protected_page]=request.request_uri
      flash[:notice] = "Please log in first."
      redirect_to :action => "login", :controller => "user"
      return false
    end
  end

  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(symbol)
    request and params[symbol]
  end

  # Redirect to the previously requested URL (if present).
  def redirect_to_forwarding_url
    if(redirect_url = session[:protected_page])
      session[:protected_page]=nil
      redirect_to redirect_url
    else
      redirect_to :action => 'index'
    end
  end

  # Return a string with the status of the remember me checkbox.
  def remember_me_string
    cookies[:remember_me] || "0"
  end


end