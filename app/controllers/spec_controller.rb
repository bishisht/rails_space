class SpecController < ApplicationController
  
  # Redirect to user hub
  def index
  	redirect_to :controller => "user", :action => "index"
  end

  # Edit the user's spec.
  def edit
  	@title = "Edit Spec"
  	@user = User.find(session[:user_id])
  	# @user.spec || Spec.new
    if not @user
      @user.spec = Spec.new
    end
  	@spec=@user.spec

  	if param_posted?(:spec)
  		if @user.spec.update_attributes(params[:spec])
  			flash[:notice] = "Changes saved."
  			redirect_to :controller => "user", :action => "index"
  		end
  	end
  end

end
