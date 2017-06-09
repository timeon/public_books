class Property < ActiveRecord::Base
  audited

  belongs_to :resource, polymorphic: true

  self.per_page = 20
  
  acts_as_api
  
  api_accessible :public do |template|
    template.add :id
    template.add :created_at
    template.add :updated_at
    template.add :resource_id
    template.add :name
    template.add :value
  end    

  api_accessible :private, :extend => :public do |template|
    template.add :resource,    :template => :public
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

