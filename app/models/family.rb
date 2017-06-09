require 'securerandom'

class Family < ActiveRecord::Base

  has_many :people, dependent: :destroy
  accepts_nested_attributes_for :people, allow_destroy:true, reject_if: proc { |attributes| attributes['first_name'].blank? and attributes['chinese_name'].blank?}

  has_attached_file :photo, styles:{medium: '300x300>', thumb: '100x100>' , icon: '50x50>' }, default_url: '/assets/:style/missing_photo.png'

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/, size:{in: 0..10.megabytes }

  belongs_to :user

  self.per_page = 500
  before_save :set_key
  before_save :set_family_name

  def to_s
    family_name
  end    

  def names
    people.where(relation:['self','spouse']).pluck(:first_name).join(" and ").strip
  end

  def emails
    people.where(relation:['self','spouse']).pluck(:email).join(" ").strip.gsub(" ", ",")
  end

  def number
    if phone.blank?
      people.pluck(:phone).first
    else
      phone
    end    
  end    

protected

  def set_key
    if !self.key
      self.key = SecureRandom.hex
    end  
  end

  def set_family_name
    self.family_name = people.first.last_name
  end


  
end

