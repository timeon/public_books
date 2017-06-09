class CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :set_course, only: [:show, :edit, :update, :destroy, :crawl]

  respond_to :html, :json, :xml

  def index
    @courses = Course.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_with(@courses)
  end

  def show
    if @course.format.name == "selection"
      sections = @course.source_url.split "/"
      @author = Author.find sections[2]
      redirect_to @author
    elsif @course.format.name == "fung"
      render @course.source_url # render static page on file 'params[:id].html.erb'
    else
      respond_with(@course)
    end
  end


  def toc
    @lessons = @course.lessons if admin?
    @lessons = @course.lessons.where(public:true) if !admin?
    respond_with(@course)
  end

  def new
    @course = Course.new
    respond_with(@course)
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    flash[:notice] = 'Course was successfully created.' if @course.save
    respond_with(@course)
  end

  def update
    flash[:notice] = 'Course was successfully updated.' if @course.update(course_params)
    respond_with(@course)
  end

  def crawl
    @course.crawl
    redirect_to @course
  end

  def destroy
    @course.destroy
    respond_with(@course)
  end

  private
    def set_course
      @course = Course.find params[:id]

      @title = @course.name
      @description = @course.description
    end

    def course_params
      params.require(:course).permit(:category_id, :medium_id, :format_id, :author_id, :crawler_id, :name, :description, :image, :source, :source_url, :image_url, :public, :subtitle)
    end
end
