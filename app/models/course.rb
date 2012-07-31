class Course < ActiveRecord::Base

	set_table_name "Courses"

	belongs_to :lecturer, :class_name => 'User', 
						:foreign_key => 'lecturer_id', 
						:counter_cache => true
	has_many :students, :order => 'created_at ASC', :dependent => :destroy
  has_many :approved_students, :class_name => 'Student', 
            :conditions => "students.status = 'approved'"
	has_many :categorizations
	has_many :categories, :through => :categorizations

	validates_presence_of :title, :description, :status
	validates_uniqueness_of :title
	validates_length_of :title, :minimum => 4
	validates_inclusion_of :status, :in => %w{completed current}
  
  def self.search(search)
    search_condition = "%" + search + "%"
    find(:all, :conditions => ['title', search_title])
  end

end
