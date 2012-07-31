class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
		t.column :title, :string, 	 :limit => 100, :default => "", :null => false
		t.column :description, :text, 						:default => "", :null => false
		t.column :lecturer_id, :integer, 	 :limit => 11, :default => 0,  :null => false
		t.column :status, :string, :limit => 20,  :default => "", :null => false
		t.column :course_limit, :string, 	 :limit => 20,  :default => "", :null => false
		t.column :created_at, :datetime
		t.column :updated_at, :datetime
		t.column :students_count, :integer, :limit =>4, :default =>0 :null => false
    end
	
  end

  def self.down
    drop_table :courses
  end
end
