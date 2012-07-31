class Category < ActiveRecord::Base

	has_many :categorizations
	has_many :courses, :through => :categorizations

	validates_presence_of :name, :short_name, :description
	validates_length_of :name, :within => 3..50
	validates_length_of :short_name, :within => 3..30
	validates_length_of :description, :maximum => 255

end
