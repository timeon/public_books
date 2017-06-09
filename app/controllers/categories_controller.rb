class CategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  def index
    @return_path = request.path
    
    if request.format.html?
      @categories = Category.paginate(:page => params[:page], :per_page => params[:per_page])
    else 
      @categories = Category.all  
    end  
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render_for_api :private, :xml  => @categories, :root => :categories, :dasherize => false  }
      format.json { render_for_api :private, :json => @categories, :root => :categories, :dasherize => false  }
    end
  end

  # GET /categories/1
  def show
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render_for_api :private, :xml  => @category, :dasherize => false }
      format.json { render_for_api :private, :json => @category, :dasherize => false }
    end    
  end

  # GET /categories/new
  def new
    @category = Category.new
    @return_path = params[:ref] ? params[:ref] : categories_path
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @return_path = params[:ref] ? params[:ref] : category_path(@category)
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    
    if @category.save
      @return_path = params[:ref] ? params[:ref] : @category  
      respond_to do |format|
        format.html { redirect_to @return_path, notice: 'Category was successfully added.' }
        format.xml  { render :status=>200, :xml =>{:id => @category.id}}
        format.json { render :status=>200, :json=>{:id => @category.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'new'}
        format.xml  { render :status=>200, :xml =>{:errors => @category.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @category.errors.full_messages}}
      end    
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      @return_path = params[:ref] ? params[:ref] : @category
      respond_to do |format|
        format.html { redirect_to @return_path, notice: 'Category was successfully updated.' }
        format.xml  { render :status=>200, :xml =>{:id => @category.id}}
        format.json { render :status=>200, :json=>{:id => @category.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'edit'}
        format.xml  { render :status=>200, :xml =>{:errors => @category.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @category.errors.full_messages}}
      end    
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Category was successfully deleted.'}
        format.xml  { render :status=>200, :xml  =>{:id => @category.id, :deleted_at => DateTime.now}}
        format.json { render :status=>200, :json =>{:id => @category.id, :deleted_at => DateTime.now}}
      end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
      @title = @category.name
      @description = @category.description
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:name, :description, :public)
    end
end

