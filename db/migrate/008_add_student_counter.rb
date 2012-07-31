class AddStudentCounter < ActiveRecord::Migration
  def self.up
	add_column :courses, :students_count, :integer, :limit => 4, :default => 0, :null => false
	Course.find(:all).each do |course|
		current_count = course.students.length
		course.update_attribute(:students_count, current_count)
	end
  end

  def self.down
	remove_column :courses, :students_count
  end

end
