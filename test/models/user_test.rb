require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should create user" do
  	user=User.new
  	user.screen_name = "bishisht2"
  	user.email="bishisht@example.com"
  	user.password="bandana"

  	assert user.save
  end
end
