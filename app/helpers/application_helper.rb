module ApplicationHelper

	def nav_link(text, controller, action="index")
		# Return a link for use un layout navigation
		link_to_unless_current text, 	:controller => controller,
										:action => action
	end

	def logged_in?
		# Return true if some user us logged in, false otherwise.
		not session[:user_id].nil?
	end

end