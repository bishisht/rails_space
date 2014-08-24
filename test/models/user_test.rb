require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should create user" do
    user=User.new
    user=users(:one)
    user.screen_name="bishisht2"
    user.email="bishisht@example.com"
    user.password="bandana"
    assert user.save
  end

  # test 'should not create an user without screen_name or email or password' do
  #   user=User.new
  #   assert !user.valid?

  #   # Checking in error for fields
  #   assert user.errors[:screen_name].any?
  #   # assert user.errors[:email].any?
  #   assert user.errors[:password].any?

  #   #Error messages
  #   assert_equal ['error in screen_name'], user.errors[:screen_name]
  #   assert_equal ['error in email'], user.errors[:email]
  #   assert_equal ['error in password'], user.errors[:password]

  #   assert !user.save
  # end



end
