<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= class_name%>.paginate(:page => params[:page], :per_page => params[:per_page])
    @return_path = request.path
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render_for_api :private, :xml  => @<%= plural_table_name %>, :root => :<%= plural_table_name %>, :dasherize => false  }
      format.json { render_for_api :private, :json => @<%= plural_table_name %>, :root => :<%= plural_table_name %>, :dasherize => false  }
    end
  end

  # GET <%= route_url %>/1
  def show
    @<%= singular_table_name %> = <%= class_name %>.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render_for_api :private, :xml  => @<%= singular_table_name %>, :dasherize => false }
      format.json { render_for_api :private, :json => @<%= singular_table_name %>, :dasherize => false }
    end    
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    @return_path = params[:ref] ? params[:ref] : <%= plural_table_name %>_path
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= singular_table_name %> = <%= class_name %>.find(params[:id])
    @return_path = params[:ref] ? params[:ref] : <%= singular_table_name %>_path(@<%= singular_table_name %>)
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    
    if @<%= orm_instance.save %>
      @return_path = params[:ref] ? params[:ref] : @<%= singular_table_name %>  
      respond_to do |format|
        format.html { redirect_to @return_path, notice: <%= "'#{human_name} was successfully added.'" %> }
        format.xml  { render :status=>200, :xml =>{:id => @<%= singular_table_name %>.id}}
        format.json { render :status=>200, :json=>{:id => @<%= singular_table_name %>.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'new'}
        format.xml  { render :status=>200, :xml =>{:errors => @<%= singular_table_name %>.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @<%= singular_table_name %>.errors.full_messages}}
      end    
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      @return_path = params[:ref] ? params[:ref] : @<%= singular_table_name %>
      respond_to do |format|
        format.html { redirect_to @return_path, notice: <%= "'#{human_name} was successfully updated.'" %> }
        format.xml  { render :status=>200, :xml =>{:id => @<%= singular_table_name %>.id}}
        format.json { render :status=>200, :json=>{:id => @<%= singular_table_name %>.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'edit'}
        format.xml  { render :status=>200, :xml =>{:errors => @<%= singular_table_name %>.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @<%= singular_table_name %>.errors.full_messages}}
      end    
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
      respond_to do |format|
        format.html { redirect_to :back, notice: <%= "'#{human_name} was successfully deleted.'" %>}
        format.xml  { render :status=>200, :xml  =>{:id => @<%= singular_table_name %>.id, :deleted_at => DateTime.now}}
        format.json { render :status=>200, :json =>{:id => @<%= singular_table_name %>.id, :deleted_at => DateTime.now}}
      end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[<%= ":#{singular_table_name}" %>]
      <%- else -%>
      params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>

