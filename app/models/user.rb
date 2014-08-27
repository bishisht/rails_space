require 'digest/sha1'

# Simple model for users
class User < ActiveRecord::Base

  has_one :spec

  # Remember me attribute. This will remember the user 
  # after they have closed the browser window.
  attr_accessor :remember_me

  # For using in view.
  attr_accessor :current_password

  # Max & min lengths for all fields
  
  #Screen name minimum length
  SCREEN_NAME_MIN_LENGTH =4 

  # Screen name maximum length
  SCREEN_NAME_MAX_LENGTH = 20

  # Minumim password length
  PASSWORD_MIN_LENGTH =4

  # Maximum password length
  PASSWORD_MAX_LENGTH= 40

  # Maximum email length
  EMAIL_MAX_LENGTH =50

  # Screen Name range
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH

  # Password Range
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH

  # Text box sizes for display in the views
  
  # Screen name size.
  SCREEN_NAME_SIZE = 20

  # Password size
  PASSWORD_SIZE = 10

  # Email size
  EMAIL_SIZE = 30



  # Validations
  validates_uniqueness_of :screen_name, :email
  validates_confirmation_of :password
  validates_length_of :screen_name, :within => SCREEN_NAME_RANGE
  validates_length_of :password, :within => PASSWORD_RANGE
  validates_length_of :email, :maximum => EMAIL_MAX_LENGTH
  # valdates_presence_of :email

  # validates_format_of :screen_name,
  #           :with => /^[A-Z0-9_]*$/i,
  #           :message => "must contain only letters," +
  #                 "numbers, and underscores"
  # validates_format_of :email,
  #           :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
  #           :message => "must be a valid email address"

  def validate
    errors.add(:email, "must be valid.") unless email.include? ("@")
    if screen_name.include?(" ")
      errors.add(:screen_name, "cannot include spaces.")
    end
  end

  # Log a user in.
  def login!(session)
    session[:user_id]=id
  end

  #Log a user out.
  def self.logout!(session,cookies)
    session[:user_id]=nil
    cookies.delete(:authorization_token)
  end

  # Clear the password (typically to suppress its display in a view.).
  def clear_password!
    self.password=nil
    self.password_confirmation = nil
    self.current_password = nil
  end

  # Remember a user for future login.
  def remember!(cookies)
    cookie_expiration = 10.years.from_now
    cookies[:remember_me] = {:value => "1",
                              :expires => cookie_expiration}
    self.authorization_token = unique_identifier
    self.save!
    cookies[:authorization_token] = {
      :value => self.authorization_token,
      :expires => cookie_expiration }
  end

  # Forget a user's login status.
  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end

  # Return true if the user wants the login status remembered.
  def remember_me?
    self.remember_me =="1"
  end

  # Return true if the password from params is correct.
  def correct_password?(params)
    current_password=params[:user][:current_password]
    password == current_password
  end

  # Generate messages for password errors.
  def password_errors(params)
    # Use User model's valid? method to ggenerate error messages
    # for a password mismatch (if any).
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    valid?
    # The current password is incorrect, so add an error message.

    errors.add(:current_password, "is incorrect")
  end

  private

  # Generate a unique identifier for a user.
  def unique_identifier
    Digest::SHA1.hexdigest ("#{self.screen_name}:#{self.password}")
  end
end
