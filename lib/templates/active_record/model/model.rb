<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>

<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %>
<% end -%>

  self.per_page = 20
  
<% if attributes.any?(&:password_digest?) -%>
  has_secure_password
<% end -%>
  acts_as_api
  
  api_accessible :public do |template|
    template.add :id
    #template.add :created_at
    #template.add :updated_at
<% attributes.select{|a| ![:has_many, :has_one, :attachment].include?(a.type)}.each do |attribute| -%>
    template.add :<%= attribute.name %><%= attribute.reference? ? "_id" : "" %>
<% end -%>
  end    

  api_accessible :private, :extend => :public do |template|
<% attributes.select(&:reference?).each do |attribute| -%>
    template.add :<%= attribute.name %>,    :template => :public
<% end -%>
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

<% end -%>
