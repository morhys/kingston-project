class Student < ActiveRecord::Base
	
	belongs_to :course, :counter_cache => true
	
	validates_presence_of :student_name, :student_email, :subjects, :status
	validates_length_of :student_name, :within => 3..25
	
	
	def before_validation
	  self.student_name.strip!
	  self.student_email.strip!
	end
	

end
