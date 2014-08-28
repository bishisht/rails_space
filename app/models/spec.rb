# User specification model.
class Spec < ActiveRecord::Base
	
	belongs_to :user

	# list of all the attributes that we will allow the user to edit
	ALL_FIELDS = %w(first_name last_name occupation gender birthdate city state zip_code)

	# array of strings specifying which fields are strings whose length should be validated.
	STRING_FIELDS = %w(first_name last_name occupation city state)
	
	# Constant for valid genders
	VALID_GENDERS = ["Male", "Female", "Other"]

	#Date validation constant
	START_YEAR = 1900

	#Range of valid dates
	VALID_DATES = DateTime.new(START_YEAR)..DateTime.now

	# Length of zip code
	ZIP_CODE_LENGTH = 5

	validates_length_of STRING_FIELDS,
						:maximum => DB_STRING_MAX_LENGTH #Defined in config/environment.rb
	
	validates_inclusion_of :gender,
							:in => VALID_GENDERS,
							:allow_nil => false,
							:message => "must select a gender"

	validates_inclusion_of :birthdate,
							:in => VALID_DATES,
							:allow_nil => false,
							:message => "please enter date"
	validates_format_of :zip_code, :with => /(^$|^[0-9]{#{ZIP_CODE_LENGTH}}$)/,
						:message => "must be a five digit number"



	# Return the full name (first plus last).
	def full_name
		[first_name, last_name].join(" ")
	end

	# Returb a sensibly formatted location string.
	def location
		[city,state, zip_code].join(" ")
	end
end
