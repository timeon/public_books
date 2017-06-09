class FixGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  
    class_option :orm, :type => :string, :default => "active_record"

    def fix_role_form
      file = "app/views/roles/_form.html.erb"
      from = "      <%= f.association :resource %>"
      to   = "      <%= f.input :resource_id %>\n      <%= f.input :resource_type %>"
      gsub_file file, from, to  
    end

    def fix_role_model
      file = File.join("app", "models", "role.rb")
      after =     /template.add :updated_at|template.add :updated_at*\n/
      inject_into_file(file, :after => after) do
        "\n    template.add :name\n    template.add :resource_id\n    template.add :resource_type\n"
      end      
    end
protected
    
# role.rb    
#  def to_s
#    resource = resource_type.constantize.find(resource_id.to_i)
#    "#{name} of #{resource_type}: #{resource}"   
#  end            

end
