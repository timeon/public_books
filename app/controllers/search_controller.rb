class SearchController < ApplicationController
  skip_authorization_check

  def show
    @title = params[:id]
    @description = params[:id]
    
    @course = Course.find_by(id: params[:id])
    @course = Course.find_by(name: params[:id]) if @course.blank?
    
    if @course
      @title = @course.name
      @description = @course.description

      if @course.format.name == "fung"
        render "courses/" + @course.source_url and return # render static page on file 'params[:id].html.erb'
      else
        render '/courses/show' and return
      end
    end     

    @lesson = Lesson.find_by(name: params[:id])
    if @lesson
      @title = @lesson.name
      render '/lessons/show'
    end   

  end

end
