class CoursesController < ApplicationController

  layout "staff"
  
  before_filter :authorize_access, :except => [:index, :login, :send_login]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    # Simple Pagination Example
    # paginate is going to access params[:page]
    #@course_pages, @courses = paginate(:courses, :per_page => 10)
    
    # Custom Pagination Example
    # step 1: set the variables you'll need
    page = (params[:page] || 1).to_i
    items_per_page = 10
    offset = (page - 1) * items_per_page
    # step 2: instead of performing a find, just get a count
    course_count = Course.count()
    # step 3: create a Paginator
    # the second argument has to be the number of ALL items on all pages
    @course_pages = Paginator.new(self, course_count, items_per_page, page)
    # step 4: only find the requested subset of @items
    @courses = Course.find(:all, :limit => items_per_page, :offset => offset)
  end

  def show
    # this action will preview the public view of the course
    @course = Course.find(params[:id])
    @all_categories = Category.find(:all, :order => 'name ASC')
    render(:template => 'shared/view_course', :layout => 'application')
  end
  alias :view_course :show
  
  def new
    @course = Course.new
    @user_list = get_user_list
    @all_categories = get_all_categories
  end

  def create
    course_params = params[:course]
    lecturer_id = course_params.delete(:lecturer_id)
    @all_categories = get_all_categories
    checked_categories = get_categories_from(params[:categories])
    removed_categories = @all_categories - checked_categories
    @course = Course.new(course_params)
    @course.lecturer = User.find(lecturer_id)
    if @course.save
      checked_categories.each {|cat| @course.categories << cat if !@course.categories.include?(cat) }
      removed_categories.each {|cat| @course.categories.delete(cat) if @course.categories.include?(cat) }
      flash[:notice] = 'Course was successfully created.'
      redirect_to :action => 'list'
    else
      @user_list = get_user_list
      render :action => 'new'
    end
  end

  def edit
    @course = Course.find(params[:id])
    @user_list = get_user_list
    @all_categories = get_all_categories
  end

  def update
    course_params = params[:course]
    lecturer_id = course_params.delete(:lecturer_id)
    @all_categories = get_all_categories
    checked_categories = get_categories_from(params[:categories])
    removed_categories = @all_categories - checked_categories
    @course = Course.find(params[:id])
    @course.lecturer = User.find(lecturer_id) if @course.lecturer_id != lecturer_id
    if @course.update_attributes(course_params)
      checked_categories.each {|cat| @course.categories << cat if !@course.categories.include?(cat) }
      removed_categories.each {|cat| @course.categories.delete(cat) if @course.categories.include?(cat) }
      flash[:notice] = 'Course was successfully updated.'
      redirect_to :action => 'list'
    else
      @user_list = get_user_list
      render :action => 'edit'
    end
  end

  def destroy
    lecturer.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  

  private #----------
  
  def get_user_list
    return User.find(:all, :order => 'last_name ASC').collect {|user| [user.full_name, user.id]}
  end

  def get_all_categories
    return Category.find(:all, :order => 'name ASC')
  end
  
  def get_categories_from(cat_list)
    cat_list = [] if cat_list.blank?
    return cat_list.collect {|cid| Category.find_by_id(cid.to_i)}.compact
  end
end
