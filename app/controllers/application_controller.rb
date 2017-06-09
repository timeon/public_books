class ApplicationController < ActionController::Base
  #layout :layout_by_resource
  #before_filter :log_request
  before_action :set_locale
  protected
 
  helper_method :admin?

  def admin?
    current_user and current_user.admin?
  end


  def ensure_admin
    if not admin?
      flash[:error] = "Not Authorized !"
      redirect_back_or_default('/')
    end
  end

  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    session[:locale] = params[:locale] || 'cn'
    logger.debug "* Locale set to '#{I18n.locale}'"

    @simplified_url  = params[:locale] ? request.original_url.gsub("locale=tw", "") : request.original_url
    @traditional_url = params[:locale] ? request.original_url.gsub("locale=cn", "locale=tw") : request.original_url + "?locale=tw"
  end

  def default_url_options(options = {})
    if session[:locale] != 'cn'
      { locale: session[:locale] }.merge options
    else
      options
    end    
  end

  def log_request
    logger.info "** referrer: #{request.referrer} #{request.xhr? ? 'ajax' : ''}"
  end
  
  def layout_by_resource
    if devise_controller?
      "application"
    elsif params[:controller] == "pages"
      "application"
    elsif request.xhr?
      "none"
    else
      "application"
    end
  end  
  
  # ensure authorization happens on every action in your application
  check_authorization :unless => :devise_controller?
  
   #Redirects to login for secure resources
  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      flash[:error] = "抱歉，您无权访问此页."
      session[:user_return_to] = nil
      redirect_to :root
    else              
      flash[:error] = "抱歉，您需要先登录."
      session[:user_return_to] = request.url
      redirect_to "/users/sign_in"
    end 
  end   

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  
  def current_user_for_audit
      @current_user
  end
  Audited.current_user_method = :current_user_for_audit
 
  #acts_as_token_authentication_handler_for User

  helper_method :admin?
 
  def admin?
    current_user and current_user.has_role? :admin
  end

private
  
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
  
 
end
