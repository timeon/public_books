class Audit < ActiveRecord::Base

  belongs_to :auditable
  belongs_to :associated
  belongs_to :user

  self.per_page = 20
  
  acts_as_api
  
  api_accessible :public do |template|
    template.add :id
    template.add :created_at
    template.add :updated_at
    template.add :auditable_id
    template.add :auditable_type
    template.add :associated_id
    template.add :associated_type
    template.add :user_id
    template.add :user_type
    template.add :username
    template.add :action
    template.add :audited_changes
    template.add :version
    template.add :comment
    template.add :remote_address
    template.add :request_uuid
  end    

  api_accessible :private, :extend => :public do |template|
    template.add :auditable,    :template => :public
    template.add :associated,    :template => :public
    template.add :user,    :template => :public
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

