# User specification controller.
class SpecController < ApplicationController

  before_filter :protect
  
  # Redirect to user hub
  def index
  	redirect_to :controller => "user", :action => "index"
  end

  # Edit the user's spec.
  def edit
  	@title = "Edit Spec"
  	@user = User.find(session[:user_id])  	
  	@spec = Spec.new
    @user.spec =@spec.user

  	if param_posted?(:spec)
  		if @spec.update_attributes(spec_params)
  			flash[:notice] = "Changes saved."
  			redirect_to :controller => "user", :action => "index"
  		end
  	end
  end

  private

    # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(symbol)
    request and params[symbol]
  end

end
