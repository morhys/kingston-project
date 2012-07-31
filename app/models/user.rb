#
# This is the User class.  Users are the authors of posts and 
# have access to the staff area.
#
class User < ActiveRecord::Base
	
	has_many :courses, :foreign_key => 'lecturer_id'
	has_many :recent_courses, :class_name => 'Course', 
				:order => 'created_at ASC', :limit => 5
	
  validates_presence_of :first_name, :last_name, :email, :display_name, :user_level, :username, :password
	validates_uniqueness_of :username
	validates_length_of :username, :within => 6..25
	validates_length_of :password, :minimum => 8
	validates_length_of :first_name, :within => 2..25
	validates_length_of :last_name, :within => 2..40
	validates_length_of :display_name, :within => 5..25
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	validates_inclusion_of :user_level, :in => 0..9
  
	attr_accessor :password
	attr_protected :hashed_password, :salt
	
	def before_create
	  self.salt = User.make_salt(self.username)
    self.hashed_password = User.hash_with_salt(@password, self.salt)
  end
  
	def before_update
	  if !@password.blank?
  	  self.salt = User.make_salt(self.username) if self.salt.blank?
      self.hashed_password = User.hash_with_salt(@password, self.salt)
    end
  end
  
  def after_save
    @password = nil
  end
  
  def before_destroy
    return false if self.id == 1
  end
  
  # Returns the user's first name and last name joined with a space.
	def full_name
	  # this is an inside comment
		self.first_name + " " + self.last_name
	end
	
	def self.authenticate(username = "", password = "")
    user = self.find(:first, :conditions => ["username = ?", username])
    return (user && user.authenticated?(password)) ? user : nil
  end
  
  def authenticated?( password = "" )
    self.hashed_password == User.hash_with_salt(password, self.salt)
  end
  
	private #----------------
  
  def self.make_salt( string )
	  return Digest::SHA1.hexdigest(string.to_s + Time.now.to_s)
  end
	
  def self.hash_with_salt(password, salt)
    return Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end
  
end
