require 'digest/sha1'
class UserController < ApplicationController
  include ApplicationHelper

  #Protect pages
  before_filter :protect, :except => [ :login, :register ]

  # This is the user hub page.
  def index
    @title= "Rails Space User Hub"
    @user=User.find(session[:user_id])    
  end



  # Enforcing only necessary parameters. 
  def user_params
    params.require(:user).permit(:screen_name, :email, :password, :attribute)
  end


  # This action is used for logging in users.
  def login
    @title="Log in to RailsSpace"
    if request.get?
      @user=User.new(:remember_me => remember_me_string)
    # if request and params[:user]
    elsif param_posted?(:user)
      @user=User.new(user_params)
      user=User.find_by_screen_name_and_password(@user.screen_name, @user.password)
      if user
        session[:user_id]=user.id
        if @user.remember_me == "1"
          user.remember!(cookies)
        else
          user.forget!(cookies)
        end
        flash[:notice] = "User #{user.screen_name} logged in!"
        redirect_to_forwarding_url
      else
        # Dont show the password again in the view.
        @user.clear_password!
        flash[:notice] = "Invalid screen_name/password combination!"
      end
    end
  end

  # This action is used for logging out users.
  def logout
    User.logout!(session,cookies)
    flash[:notice] ="Logged out!"
    redirect_to(:action => 'index', :controller => 'site')
  end

  # Edit the user's basic info.
  def edit
    @title = "Edit basic info"
    @user = User.find(session[:user_id])
    if param_posted?(:user)
      attribute = params[:attribute]
      case attribute
      when "email"
        try_to_update @user, attribute
      when "password"
        if @user.correct_password?(params)
          try_to_update @user, attribute
        else
          @user.password_errors(params)
        end
      end
    end
    # For security purposes, never fill in password fields.
    @user.clear_password!
  end


  # This action is used for registering users.
  def register
  	@title="Register"
    if param_posted?(:user)
  		@user=User.create(user_params)
  		if @user.save
        # session[:user_id]=@user.id
        @user.login!(session)
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to_forwarding_url         
      else
        @user.clear_password!
      end
  	end
  end


  
  # Private actions.
  private

  # Protect a page from unauthorized access.
  def protect
    unless session[:user_id]
      flash[:notice] = "Please log in first."
      redirect_to :action => "login"
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

  # Try to update the user, redirecting if successful.
  def try_to_update(user, attribute)
    if user.update_attributes(user_params)
      flash[:notice] = "User #{attribute} updated."
      redirect_to :action => "index"
    end
  end

end