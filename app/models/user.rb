require 'securerandom'

class User < ActiveRecord::Base
  audited except: [:last_sign_in_at, :current_sign_in_at, :key, :sign_in_count]
  before_save :ensure_authentication_token

  has_many :properties, as: :resource, dependent: :destroy
  rolify
  acts_as_tagger
  acts_as_token_authenticatable
  devise :invitable, 
         :database_authenticatable, 
         :registerable, 
         #:confirmable,
         :recoverable,
         #:rememberable, 
         :trackable,
         :validatable
         #:lockable,
         #:timeoutable
         #:omniauthable
        
  def timeout_in
    if Rails.env.development?
      24.hour
    else
      15.minute
    end
  end
        
  has_attached_file :avatar, styles:{medium: '300x300>', thumb: '100x100>' , icon: '50x50>' }, default_url: '/assets/:style/missing_avatar.jpg'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/, size:{in: 0..5000.kilobytes }

  before_save :set_key
  
  self.per_page = 20
  
  acts_as_api
  
  api_accessible :public do |template|
    template.add :id
    template.add :first_name
    template.add :last_name
    template.add :display_name
    template.add :gender
    template.add :phone
    template.add :email
    template.add :authentication_token
    template.add :created_at
    template.add :updated_at
  end    

  api_accessible :private,        :extend   => :public do |template|
    template.add :properties,     :template => :public
  end    
  
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end  
  
  def to_s
    if self.respond_to?("name")
      self.name
    elsif self.respond_to?("display_name")
      self.display_name
    else
      "#{self.class.name} #{self.class.id}"   
    end
  end     
  
  def name
    if display_name
      display_name
    elsif !first_name.blank? or !last_name.blank?   
      "#{first_name} #{last_name}"
    else
      email.split('@')[0].humanize
    end
  end


  def self.add name, email, role
    user = User.find_by_email email
    if !user
     user = User.create display_name:name, email:email, password: "changeme", password_confirmation: "changeme"
     user.add_role role
     #user.confirm!
     puts "  added #{user.name} #{user.email}"
    end
  end

  def set_key
    self.key = SecureRandom.hex
  end
end

