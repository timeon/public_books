# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController

 # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!

        if params[:role] and params[:resource_type] and params[:resource_id]
          begin
            role = Role.find_or_create_by name: params[:role], resource_type: params[:resource_type], resource_id: params[:resource_id]
            UsersRoles.find_or_create_by user: resource, role: role
          rescue
          end
        end          
       
        respond_to do |format|
          format.html { redirect_to after_inactive_sign_up_path_for(resource)}
          format.xml  { render :xml => resource }
          format.json { render :json => resource }
        end
      end
    else
      clean_up_passwords resource
      #respond_with resource
      respond_to do |format|
        format.html { redirect_to after_inactive_sign_up_path_for(resource)}
        format.xml  { render :xml => resource }
        format.json { render :json => resource }
      end
    end
  end
  
  private

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
  
  # Only allow a trusted parameter "white list" through.
  def sign_up_params
    params.require(:user).permit(:first_name, :avatar, :last_name, :display_name, :gender, :phone, :email, :password, :password_confirmation, )
  end
end

