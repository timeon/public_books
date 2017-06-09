class AuthorsController < ApplicationController
  load_and_authorize_resource
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :xml

  def index
    @authors = Author.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_with(@authors)
  end

  def show
    respond_with(@author)
  end

  def new
    @author = Author.new
    respond_with(@author)
  end

  def edit
  end

  def create
    @author = Author.new(author_params)
    flash[:notice] = 'Author was successfully created.' if @author.save
    respond_with(@author)
  end

  def update
    flash[:notice] = 'Author was successfully updated.' if @author.update(author_params)
    respond_with(@author)
  end

  def destroy
    @author.destroy
    respond_with(@author)
  end

  private
    def set_author
      @author = Author.find(params[:id])
      @title = @author.name
      @description = @author.description
    end

    def author_params
      params.require(:author).permit(:name, :english_name, :description, :photo)
    end
end
