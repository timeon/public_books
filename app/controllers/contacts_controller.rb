class ContactsController < ApplicationController
  load_and_authorize_resource
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :xml

  def get_all
    if admin? or coworker?
      
      if !params[:disabled] || params[:disabled] == false
         disabled = false;
      else
         disabled = true;
      end
      
      per_page = params[:per_page] || 10
      
      if params[:page]
        @contacts = Contact.where(:disabled => disabled).paginate(:page => params[:page], :per_page=>per_page)
      else
        @contacts = Contact.where(:disabled => disabled)
      end  
        @contacts = @contacts.order(:adult_1_last_name)
    elsif logged_in?
      match_contacts_to_user
      @contacts = current_user.contacts
    else
      @contacts = Array.new
    end      
  end
  

  def index
    #@contacts = Contact.paginate(:page => params[:page], :per_page => params[:per_page])
    get_all

    respond_with(@contacts)
  end

  def list
    get_all
  end
  
  def photo
    get_all
  end
  
  def print
    get_all
  end
  
  def print_photo
    get_all
  end

  def show
    respond_with(@contact)
  end

  def check_all
    get_all
    
    @contacts.each do |contact|
      if (contact.adult_1_email or contact.adult_2_email) and !contact.verified   
        #ContactMailer.check_contact(contact).deliver
        #logger.info "mail #{contact.adult_1_email} for verification"
        contact.shadow
      end
    end
          
    redirect_to contacts_path
  end

  def verify
    @contact = Contact.find(params[:id])
    
    if @contact
      @contact.verified = true
    end
    
    respond_to do |format|
      if @contact.save
        format.html { redirect_to contact_path(@contact, :key=>@contact.key)}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  def check
    @contact = Contact.find(params[:id])
    
    if @contact.adult_1_email or @contact.adult_2_email  
      ContactMailer.check_contact(@contact).deliver
    end
          
    redirect_to contact_path(@contact, :key=>@contact.key)
  end
  


  def new
    @contact = Contact.new
    respond_with(@contact)
  end

  def edit
  end

  def create
    @contact = Contact.new(contact_params)
    flash[:notice] = 'Contact was successfully created.' if @contact.save
    respond_with(@contact)
  end

  def update
    flash[:notice] = 'Contact was successfully updated.' if @contact.update(contact_params)
    respond_with(@contact)
  end

  def destroy
    @contact.destroy
    respond_with(@contact)
  end

  def match_contacts_to_user
    contacts  = Contact.where(adult_1_email: current_user.email)
    contacts += Contact.where(adult_2_email: current_user.email)
    contacts.each do |contact|
      contact.user = current_user
      contact.save 
    end    
  end


  private
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:home_phone, :street_no_and_name, :city, :state, :zip, :country, :adult_1_first_name, :adult_1_last_name, :adult_1_chinese_name, :adult_1_email, :adult_1_phone, :adult_1_phone_ext, :adult_2_first_name, :adult_2_last_name, :adult_2_chinese_name, :adult_2_email, :adult_2_phone, :adult_2_phone_ext, :child_1_relation, :child_1_first_name, :child_1_last_name, :child_1_chinese_name, :child_2_relation, :child_2_first_name, :child_2_last_name, :child_2_chinese_name, :child_3_relation, :child_3_first_name, :child_3_last_name, :child_3_chinese_name, :child_4_relation, :child_4_first_name, :child_4_last_name, :child_4_chinese_name, :child_5_relation, :child_5_first_name, :child_5_last_name, :child_5_chinese_name, :photo, :photo_number, :user_id, :verified, :disabled, :key, :note)
    end
end
