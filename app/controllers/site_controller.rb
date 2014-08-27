# Site controller is used to generate static pages
class SiteController < ApplicationController
  
  # RailsSpace home page.
  def index
  	@title="Welcome to RailsSpace!"
  end

  # About rails space
  def about
  	@title="About RailsSpace"

  end

  # Display help
  def help
  	@title="RailsSpace Help"
  end
end
