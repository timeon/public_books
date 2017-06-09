class Author < ActiveRecord::Base
  has_attached_file :photo, styles:{medium: '300x300>', thumb: '100x100>' , icon: '50x50>' }, default_url: '/assets/:style/missing_photo.png'

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/, size:{in: 0..10.megabytes }

  has_many :courses, dependent: :destroy 

  self.per_page = 20
  
  acts_as_api
  
  api_accessible :public do |template|
    template.add :id
    #template.add :created_at
    #template.add :updated_at
    template.add :name
    template.add :english_name
    template.add :description
  end    

  api_accessible :private, :extend => :public do |template|
  end    
  
  def to_s
     name + " " + (english_name || "")  
  end    
  
end

