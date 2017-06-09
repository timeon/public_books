class PagesController < ApplicationController
  #load_and_authorize_resource
  skip_authorization_check
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate_user!, only: [:show, :app, :qr, :thank_you, :terms, :home]

  # GET /pages
  def index
    @pages = Page.paginate(:page => params[:page], :per_page => params[:per_page])
    @return_path = request.path
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render_for_api :private, :xml  => @pages, :root => :pages, :dasherize => false  }
      format.json { render_for_api :private, :json => @pages, :root => :pages, :dasherize => false  }
    end
  end

  # GET /pages/1
  def show
    if @page
      render text: @page.content,  layout: true # render page content stored in DB
    else
      render params[:id] # render static page on file 'params[:id].html.erb'
    end
  end

  def home
    @description = "專門為蒙恩的基督徒準備的一個網站，提供基督門徒聖經課程和傳道課程，可以用自来學或訓練同工。傳道課程是一個改變生命的課程！把所學到的整合到日常生活中，學習調整生活，重新編排優先次序及調整活動焦點。"
    @lesson = Lesson.find_by_name("传道课程简介")
    @lesson = Lesson.first if !@lesson
    render layout: true # render static page on file home.html.erb
  end
    
  def terms 
    render layout: true # render static page on file terms.html.erb
  end 

  # GET /pages/new
  def new
    @page = Page.new
    @return_path = params[:ref] ? params[:ref] : pages_path
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
    @return_path = params[:ref] ? params[:ref] : page_path(@page)
  end

  # POST /pages
  def create
    @page = Page.new(page_params)
    
    if @page.save
      @return_path = params[:ref] ? params[:ref] : @page  
      respond_to do |format|
        format.html { redirect_to @return_path, notice: 'Page was successfully added.' }
        format.xml  { render :status=>200, :xml =>{:id => @page.id}}
        format.json { render :status=>200, :json=>{:id => @page.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'new'}
        format.xml  { render :status=>200, :xml =>{:errors => @page.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @page.errors.full_messages}}
      end    
    end
  end

  # PATCH/PUT /pages/1
  def update
    if @page.update(page_params)
      @return_path = params[:ref] ? params[:ref] : @page
      respond_to do |format|
        format.html { redirect_to @return_path, notice: 'Page was successfully updated.' }
        format.xml  { render :status=>200, :xml =>{:id => @page.id}}
        format.json { render :status=>200, :json=>{:id => @page.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'edit'}
        format.xml  { render :status=>200, :xml =>{:errors => @page.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @page.errors.full_messages}}
      end    
    end
  end

  # DELETE /pages/1
  def destroy
    @page.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Page was successfully deleted.'}
        format.xml  { render :status=>200, :xml  =>{:id => @page.id, :deleted_at => DateTime.now}}
        format.json { render :status=>200, :json =>{:id => @page.id, :deleted_at => DateTime.now}}
      end    
  end

  def token
    render :partial => 'token'
  end
   
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_page
    begin
      @page = Page.find(params[:id])
    rescue
      @page = Page.find_by name: params[:id]
    end
  end

  # Only allow a trusted parameter "white list" through.
  def page_params
    params.require(:page).permit(:name, :content, :position, :order, :visible)
  end

end
