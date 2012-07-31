class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
		t.column :course_id, :integer, 					:default => 0,  :null => false
		t.column :ucas_id, :integer, 					:default => 0,  :null => false
		t.column :student_name, :string, 		 :limit => 25,  :default => "", :null => false
		t.column :student_email, :string, 		 :limit => 25,  :default => "", :null => false
		t.column :tel, :integer, 					:default => 0,  :null => false
		t.column :subjects, :text, 						:default => "", :null => false
		t.column :status, :string, 		 :limit => 25,  :default => "", :null => false
		t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :students
  end
end
