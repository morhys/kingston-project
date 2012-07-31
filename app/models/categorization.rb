class Categorization < ActiveRecord::Base
	set_table_name "categories_courses"
	belongs_to :course
	belongs_to :category
end
