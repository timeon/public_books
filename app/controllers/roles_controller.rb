class RolesController < ApplicationController
  load_and_authorize_resource
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /roles
  def index
    @roles = Role.paginate(:page => params[:page], :per_page => params[:per_page])
    @return_path = request.path
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render_for_api :private, :xml  => @roles, :root => :roles, :dasherize => false  }
      format.json { render_for_api :private, :json => @roles, :root => :roles, :dasherize => false  }
    end
  end

  # GET /roles/1
  def show
    @role = Role.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render_for_api :private, :xml  => @role, :dasherize => false }
      format.json { render_for_api :private, :json => @role, :dasherize => false }
    end    
  end

  # GET /roles/new
  def new
    @role = Role.new
    @return_path = params[:ref] ? params[:ref] : roles_path
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
    @return_path = params[:ref] ? params[:ref] : role_path(@role)
  end

  # POST /roles
  def create
    @role = Role.new(role_params)
    
    if @role.save
      @return_path = params[:ref] ? params[:ref] : @role  
      respond_to do |format|
        format.html { redirect_to @return_path, notice: 'Role was successfully added.' }
        format.xml  { render :status=>200, :xml =>{:id => @role.id}}
        format.json { render :status=>200, :json=>{:id => @role.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'new'}
        format.xml  { render :status=>200, :xml =>{:errors => @role.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @role.errors.full_messages}}
      end    
    end
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update(role_params)
      @return_path = params[:ref] ? params[:ref] : @role
      respond_to do |format|
        format.html { redirect_to @return_path, notice: 'Role was successfully updated.' }
        format.xml  { render :status=>200, :xml =>{:id => @role.id}}
        format.json { render :status=>200, :json=>{:id => @role.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'edit'}
        format.xml  { render :status=>200, :xml =>{:errors => @role.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @role.errors.full_messages}}
      end    
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Role was successfully deleted.'}
        format.xml  { render :status=>200, :xml  =>{:id => @role.id, :deleted_at => DateTime.now}}
        format.json { render :status=>200, :json =>{:id => @role.id, :deleted_at => DateTime.now}}
      end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:name, :resource_id, :resource_type)
    end
end

