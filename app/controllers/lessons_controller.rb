class LessonsController < ApplicationController
  load_and_authorize_resource
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :xml

  def index
    @lessons = Lesson.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_with(@lessons)
  end

  def show
    @lesson.load_body
    respond_with(@lesson)
  end

  def new
    @lesson = Lesson.new(course_id:params[:course])
    respond_with(@lesson)
  end

  def edit
  end

  def create
    @lesson = Lesson.new(lesson_params)
    flash[:notice] = 'Lesson was successfully created.' if @lesson.save
    respond_with(@lesson)
  end

  def update
    flash[:notice] = 'Lesson was successfully updated.' if @lesson.update(lesson_params)
    respond_with(@lesson)
  end

  def up
    @lesson.update_attribute :row_order_position, :up
    @course = @lesson.course
    render '/courses/show'
  end

  def down
    @lesson.update_attribute :row_order_position, :down
    @course = @lesson.course
    render '/courses/show'
  end

  def first
    @lesson.update_attribute :row_order_position, :first
    @course = @lesson.course
    render '/courses/show'
  end

  def last
    @lesson.update_attribute :row_order_position, :last
    @course = @lesson.course
    render '/courses/show'
  end

  
  def destroy
    @lesson.destroy
    respond_with(@lesson)
  end

  def delete
    course = @lesson.course
    @lesson.destroy
    redirect_to course
  end


  private
    def set_lesson
      @lesson = Lesson.find(params[:id])
      @title = @lesson.course.name + " - " + @lesson.name
      @description = @lesson.description
    end

    def lesson_params
      params.require(:lesson).permit(:course_id, :name, :description, :body, :image, :author_id, :style, :public)
    end
end
