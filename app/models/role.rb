class Role < ActiveRecord::Base
  audited
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true
  
  scopify

  self.per_page = 20
  
  acts_as_api
  
  api_accessible :public do |template|
    template.add :id
    template.add :created_at
    template.add :updated_at
    template.add :name
    template.add :resource_id
    template.add :resource_type

  end    

  api_accessible :private, :extend => :public do |template|
  end    
  
  def to_s
    if resource_id
      "#{self.name} for #{resource}"
    else
      name
    end  
  end     
  
end

