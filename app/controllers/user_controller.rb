class UserController < ApplicationController
  def index
    @title= "Rails Space User Hub"
  end

  def user_params
    params.require(:user).permit(:screen_name, :email, :password )
  end

  def register
  	@title="Register"
  	if request.post? and params[:user]
  		@user=User.create(user_params)
  		if @user.save
        flash[:notice] = "User #{@user.screen_name} created!"
  			redirect_to :action => "index"
  		end
  	end
  end
end
