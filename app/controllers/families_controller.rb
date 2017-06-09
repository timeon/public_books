class FamiliesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only =>  [:show, :new, :create, :edit, :update, :verify, :reset, :delete, :upload]
  skip_authorization_check :only => [:show, :new, :create, :edit, :update, :verify, :reset, :delete, :upload]

  before_action :set_family, only:  [:show, :edit, :update, :destroy, :delete, :verify, :reset, :check, :upload]
  before_action :set_admin

  respond_to :html, :json, :xml

  def index
    @families = Family.where(disabled: [params[:disabled] || false, nil]).order(:family_name)
    @families = @families.where(verified: params[:verified]) if params[:verified]
    @families = @families.where(sent: params[:sent]) if params[:sent]
    @families = @families.paginate(:page => params[:page], :per_page => params[:per_page])
    @print = params[:print]

    respond_to do |format|
      format.html
      format.pdf
    end    
  end

  def list
    @families = Family.where(disabled:false).order(:family_name)
    respond_with(@families)
  end

  def logout
    sign_out current_user
    redirect_to root_path
  end

  def reset_all
    if admin?
      Family.update_all(sent:false, verified:false)
      redirect_to families_path
    else
      render text: 'Access denied'
    end
  end


  def reset
    if admin?
      @family.update(sent:false, verified:false)
      redirect_to :back
    else
      render text: 'Access denied'
    end
  end

  def check_all
    if admin?
      Family.where(disabled:false, sent:false, verified:false).each do |family|
        begin
          FamilyMailer.check_family(family).deliver
          family.update(sent:true, sent_at:DateTime.now)
        rescue
        end
      end
      redirect_to families_path
    else
      render text: 'Access denied'
    end
  end

  def check
    if admin?
      FamilyMailer.check_family(@family).deliver
      @family.update(sent:true, sent_at:DateTime.now)
      redirect_to  @family
    else
      render text: 'Access denied'
    end
  end

  def show
    flash[:notice] = 'For printing only, No online access by others'

    if params[:key] == @family.key or admin?
      respond_with(@family)
    else
      render text: 'Access denied'
    end
  end

  def new
    @family = Family.new
    5.times {@family.people.build}

    respond_with(@family)
  end

  def upload
    if params[:key] != @family.key
      render text: 'Access denied'      
    end
  end

  def edit
    if params[:key] == @family.key
      (7 - @family.people.count).times {@family.people.build}
      respond_with(@family)
    else
      render text: 'Access denied'      
    end
  end

  def create
    emails = family_params[:people_attributes].map{|p|p[1]["email"]}.delete_if{|e|e.blank?}
    exsiting_people = Person.where(email:emails)
    if exsiting_people.present?
      @family = exsiting_people.first.family
      FamilyMailer.check_family(@family).deliver
      render 'exist'
    else  
      @family = Family.create(family_params)
      redirect_to family_path(@family, key:@family.key)
    end

  end


  def verify
    flash[:notice] = 'Family info is verified.' 
    @family.update(verified:true, verified_at:DateTime.now)
    redirect_to family_path(@family, key:@family.key)
  end  

  def update
    if params[:key] == @family.key
      flash[:notice] = 'Family was successfully updated.' if @family.update(family_params)
      redirect_to family_path(@family, key:@family.key)
    else
      render text: 'Access denied'      
    end
  end  

  def destroy
    if params[:key] == @family.key
      @family.destroy
      redirect_to families_path
    else
      render text: 'Access denied'      
    end
  end
  alias :delete :destroy

  private
    def set_family
      @family = Family.find(params[:id])
    end

    def set_admin
      @admin = admin?
    end

    def family_params
      params.require(:family).permit(:user_id, :phone, :street, :city, :state, :zip, :country, :photo, :verified, :sent, :disabled, :one_more_year, :key, :note, people_attributes: [:id, :relation, :first_name, :last_name, :chinese_name, :email, :phone, :phone_ext])
    end
end
