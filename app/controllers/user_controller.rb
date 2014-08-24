class UserController < ApplicationController

  #Protect pages
  before_filter :protect, :except => [ :login, :register ]

  # This is the user hub page.
  def index
    @title= "Rails Space User Hub"
    # This will be a protedted page for viewing user information.
  end

  # This action is used for simple login functionality
  def login
    # This action is used for logging in users.
    @title="Log in to RailsSpace"
    if request and params[:user]
      @user=User.new(user_params)
      user=User.find_by_screen_name_and_password(@user.screen_name, @user.password)
      if user
        session[:user_id]=user.id
        flash[:notice] = "User #{user.screen_name} logged in!"
        if (redirect_url = session[:protected_page])
          session[:protected_page]=nil
          redirect_to redirect_url
        else
          redirect_to :action => "index"
        end
      else
        # Dont show the password in the view.
        @user.password=nil
        flash[:notice] = "Invalid screen_name/password combination!"
      end
    end
  end

  # This action is used for logging out users.
  def logout
    session[:user_id]=nil
    flash[:notice] ="Logged out!"
    redirect_to(:action => 'index', :controller => 'site')
  end

  def user_params
    params.require(:user).permit(:screen_name, :email, :password )
  end

  # This action is used for registering users.
  def register
  	@title="Register"
  	if request.post? and params[:user]
  		@user=User.create(user_params)
  		if @user.save
        session[:user_id]=@user.id
        flash[:notice] = "User #{@user.screen_name} created!"
        if (redirect_url = session[:protected_page])
          session[:protected_page] = nil
          redirect_to redirect_url
        else
          redirect_to :action => 'index'
        end  			
  		end
  	end
  end

  # Private actions.

  private

  # Protect a page from unauthorized access.
  def protect
    unless session[:user_id]
      session[:protected_page]=request.request_uri
      flash[:notice] = "Please log in first."
      redirect_to :action => "login", :controller => "user"
      return false
    end
  end


end