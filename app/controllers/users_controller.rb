class UsersController < ApplicationController
  load_and_authorize_resource 
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action  :authenticate_user!, only: [:create]
  skip_before_filter :verify_authenticity_token, only: [:create]

  # GET /users
  def index

    if params[:role]
      if params[:chain_id] 
        resource = Chain.find(params[:chain_id])
      elsif params[:school_id] 
        resource = School.find(params[:school_id])
      elsif params[:room_id] 
        resource = Room.find(params[:room_id])
      elsif params[:child_id] 
        resource = Child.find(params[:child_id])
      elsif params[:user_id] 
        resource = User.find(params[:user_id])
      else
        resource = nil  
      end 
      @users = User.with_role(params[:role], resource).paginate(:page => params[:page], :per_page => params[:per_page])
    else  
      @users = User.paginate(:page => params[:page], :per_page => params[:per_page])
    end

    @return_path = request.path
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render_for_api :private, :xml  => @users, :root => :users, :dasherize => false  }
      format.json { render_for_api :private, :json => @users, :root => :users, :dasherize => false  }
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render_for_api :private, :xml  => @user, :dasherize => false }
      format.json { render_for_api :private, :json => @user, :dasherize => false }
    end    
  end

  # GET /users/new
  def new
    @user = User.new
    @return_path = params[:ref] ? params[:ref] : users_path
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @return_path = params[:ref] ? params[:ref] : user_path(@user)
  end

  # POST /users
  def create
    @user = User.find_by_email params[:user][:email]
    if @user
      redirect_to @user and return 
    end

    @user = User.new(sign_up_params)
    
    if @user.save
      @return_path = params[:ref] ? params[:ref] : @user  
      redirect_to @user
    else
      respond_to do |format|
        format.html { render action: 'new'}
        format.xml  { render :status=>200, :xml =>{:errors => @user.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @user.errors.full_messages}}
      end    
    end
  end

  # PATCH/PUT /users/1
  def update
    
    role = Role.find params[:user][:roles] if params[:user][:roles]
    
    if role
      @user.remove_role @user.roles.first
      @user.add_role role, @user.publisher 
    end
    
    if @user.update(user_params)
      @return_path = params[:ref] ? params[:ref] : @user
      respond_to do |format|
        format.html { redirect_to @return_path, notice: 'User was successfully updated.' }
        format.xml  { render :status=>200, :xml =>{:id => @user.id}}
        format.json { render :status=>200, :json=>{:id => @user.id}}
      end    
    else
      respond_to do |format|
        format.html { render action: 'edit'}
        format.xml  { render :status=>200, :xml =>{:errors => @user.errors.full_messages}}
        format.json { render :status=>200, :json=>{:errors => @user.errors.full_messages}}
      end    
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'User was successfully deleted.'}
        format.xml  { render :status=>200, :xml  =>{:id => @user.id, :deleted_at => DateTime.now}}
        format.json { render :status=>200, :json =>{:id => @user.id, :deleted_at => DateTime.now}}
      end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :avatar, :last_name, :display_name, :gender, :phone, :email, :publisher_id)
    end
    
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end

