class UserController < ApplicationController
  def index
    @title= "Rails Space User Hub"
  end

  def login
    @title="Log in to RailsSpace"
    if request and params[:user]
      @user=User.new(user_params)
      user=User.find_by_screen_name_and_password(@user.screen_name, @user.password)
      if user
        session[:user_id]=user.id
        flash[:notice] = "User #{user.screen_name} logged in!"
        redirect_to :action => 'index'
      else
        # Dont show the password in the view.
        @user.password=nil
        flash[:notice] = "Invalid screen_name/password combination!"
      end
    end
  end

  def user_params
    params.require(:user).permit(:screen_name, :email, :password )
  end

  def register
  	@title="Register"
  	if request.post? and params[:user]
  		@user=User.create(user_params)
  		if @user.save
        session[:user_id]=@user.id
        flash[:notice] = "User #{@user.screen_name} created!"
  			redirect_to :action => "index"
  		end
  	end
  end
end
