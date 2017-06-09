class PropertiesController < ApplicationController
  load_and_authorize_resource
  before_action :set_property, only: [:show, :edit, :update, :destroy]

  # GET /properties
  def index
    @properties = Property.paginate(:page => params[:page], :per_page => params[:per_page])
    @return_path = request.path
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render_for_api :private, :xml  => @properties, :root => :properties, :dasherize => false  }
      format.json { render_for_api :private, :json => @properties, :root => :properties, :dasherize => false  }
    end
  end

  # GET /properties/1
  def show
    @property = Property.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render_for_api :private, :xml  => @property, :dasherize => false }
      format.json { render_for_api :private, :json => @property, :dasherize => false }
    end    
  end

  # GET /properties/new
  def new
    @property = Property.new
    @return_path = params[:ref] ? params[:ref] : properties_path
  end

  # GET /properties/1/edit
  def edit
    @property = Property.find(params[:id])
    @return_path = params[:ref] ? params[:ref] : property_path(@property)
  end

  # POST /properties
  def create
    @property = Property.new(property_params)
    
    if @property.save
      @return_path = params[:ref] ? params[:ref] : @property  
      respond_to do |format|
        format.html { redirect_to @return_path, notice: 'Property was successfully added.' }
        format.xml  { render :status=>200, :xml =>{:id => @property.id}}
        format.json { render :status=>200, :json=>{:id => @property.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'new'}
        format.xml  { render :status=>200, :xml =>{:errors => @property.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @property.errors.full_messages}}
      end    
    end
  end

  # PATCH/PUT /properties/1
  def update
    if @property.update(property_params)
      @return_path = params[:ref] ? params[:ref] : @property
      respond_to do |format|
        format.html { redirect_to @return_path, notice: 'Property was successfully updated.' }
        format.xml  { render :status=>200, :xml =>{:id => @property.id}}
        format.json { render :status=>200, :json=>{:id => @property.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'edit'}
        format.xml  { render :status=>200, :xml =>{:errors => @property.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @property.errors.full_messages}}
      end    
    end
  end

  # DELETE /properties/1
  def destroy
    @property.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Property was successfully deleted.'}
        format.xml  { render :status=>200, :xml  =>{:id => @property.id, :deleted_at => DateTime.now}}
        format.json { render :status=>200, :json =>{:id => @property.id, :deleted_at => DateTime.now}}
      end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def property_params
      params.require(:property).permit(:resource_id, :resource_type, :name, :value)
    end
end

