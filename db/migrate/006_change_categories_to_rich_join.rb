class ChangeCategoriesToRichJoin < ActiveRecord::Migration
  def self.up

	add_column :categories_courses, :id, :primary_key
	


  def self.down
	remove_column :categories_courses, :id
  end
end
