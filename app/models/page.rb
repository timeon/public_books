class Page < ActiveRecord::Base
  audited

  self.per_page = 20
  
  acts_as_api
  
  api_accessible :public do |template|
    template.add :id
    template.add :created_at
    template.add :updated_at
    template.add :name
    template.add :content
    template.add :position
    template.add :order
    template.add :visible
  end    

  api_accessible :private, :extend => :public do |template|
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
  
end

