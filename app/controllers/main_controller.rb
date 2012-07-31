class MainController < ApplicationController
  
  before_filter :authorize_access, :except => [:index, :login, :send_login]
  
  before_filter :set_all_categories, :set_archive_list
  
  def index
    list
    render(:action => 'list')
  end

  def list
		@courses = Course.paginate(:all, 
		    #:include => [:lecturer, :categories],
		    :conditions => "status = 'current'",
		    :order => 'courses.created_at DESC', 
		    :per_page => 5, :page => params[:page])
  end

  def category
		@courses = Course.paginate(:all, 
			:include => [:lecturer, :categories],
			:conditions => ["status = 'current' AND categories.id = ?", params[:id]], 
			:order => "courses.created_at DESC", 
	    :per_page => 5, :page => params[:page])
		render(:action => 'list')
  end

  def archive
    #maybe move to a method called 'get_start_and_end_times'
    start_time = Time.mktime( params[:year] || 2011,
	                           params[:month] || 1, 
	                            params[:day] || 1)
		end_time = start_time.next_month
		@courses = Course.paginate(:all, 
			:include => [:lecturer, :categories],
			:conditions => ["status = 'completed'"], 
			:order => "courses.created_at DESC", 
	    :per_page => 5, :page => params[:page])
		render(:action => 'list')
  end

  def view_course
		@course = Course.find(params[:id], :include => [:lecturer, :categories, :approved_students])
		@student = Student.new
    render(:template => 'shared/view_course')
  end
  
  def add_student
		@student = Student.new(params[:student])
		@course = Course.find(params[:id])
		@student.course = @course
		@student.status = "new"
		if @student.save
			flash[:notice] = 'Student sent for approval'
			redirect_to(:action => 'view_course', :id => @course.id)
		else
      render(:template => 'shared/view_course')
		end
  end

  private #-------
  
  
  
  def set_all_categories
    @all_categories = Category.find(:all, :order => 'name ASC')
  end
  
  def set_archive_list
    courses = Course.find(:all, :conditions => ["status = 'Completed'"], :order => "title ASC")
		@archive_list = courses.collect do |p|
		  [p.title]
		end
		@archive_list.uniq!
  end
end
