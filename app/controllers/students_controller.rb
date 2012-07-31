class StudentsController < ApplicationController

  layout "staff"

  before_filter :authorize_access

  def index
    list
    render(:action => 'list')
  end
  
  def list
    case params[:status]
    when 'approved'
      @students = Student.find(:all, :conditions => "status = 'approved'", :order => 'created_at DESC')
    when 'declined'
      @students = Student.find(:all, :conditions => "status = 'declined'", :order => 'created_at DESC')
    when 'all'
      @students = Student.find(:all, :order => 'created_at DESC')
    else 'new'
      @students = Student.find(:all, :conditions => "status = 'new'", :order => 'created_at DESC')
    end
    
  end

  def show
    @student = Student.find(params[:id])
  end
  
  def set_status
    begin
      status = params[:commit] || ""
      checked_items = params[:studentlist]
      checked_items.each do |id|
      Student.update(id.to_i, :status => status.downcase)
      end
      flash[:notice] = "The checked items have been updated."
      redirect_to(:action => 'list')
    rescue
      flash[:notice] = "An unknown error occurred."
      redirect_to(:action => 'list')
    end
  end

end
