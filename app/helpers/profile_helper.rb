# This contains actions that are needed in profile views
module ProfileHelper
	# Return the user's profile URL.
	def profile_for(user)
		profile_url(:screen_name => user.screen_name)
	end
end
