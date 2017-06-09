class Category < ActiveRecord::Base
  audited
  has_many :courses, dependent: :destroy 

  self.per_page = 20
  
  acts_as_api
  
  api_accessible :public do |template|
    template.add :id
    #template.add :created_at
    #template.add :updated_at
    template.add :name
    #template.add :description
    template.add :keywords,   :template => :public
  end    

  api_accessible :private, :extend => :public do |template|
    template.add :keywords,   :template => :public
  end    
  
  def to_s
    if self.respond_to? "name"
      self.name
    elsif self.respond_to? "display_name"
      self.display_name
    elsif self.respond_to? "label"
      self.label
    else
      "#{self.class.name} #{self.id}"   
    end
  end     
  
end

