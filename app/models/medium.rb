class Medium < ActiveRecord::Base


  self.per_page = 20
  
  acts_as_api
  
  api_accessible :public do |template|
    template.add :id
    #template.add :created_at
    #template.add :updated_at
    template.add :name
    template.add :icon
  end    

  api_accessible :private, :extend => :public do |template|
  end    
  
  def to_s
    if self.respond_to? "name"
      str = self.name
    elsif self.respond_to? "display_name"
      str = self.display_name
    elsif self.respond_to? "label"
      str = self.label
    end
      
    if str.blank?
      str = "#{self.class.name} #{self.id}"   
    end
    str
  end    
  
end

