class AddCourseCounter < ActiveRecord::Migration
  def self.up
	add_column :users, :courses_count, :integer, :limit => 6, :default => 0, :null => false
    User.find(:all).each do |user|
      current_count = user.courses.length
      user.update_attribute(:courses_count, current_count)
    end
  end

  def self.down
	remove_column :users, :courses_count
  end
end
