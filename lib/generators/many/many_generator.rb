class ManyGenerator < Rails::Generators::NamedBase
    argument :belonging, type: :string, banner: "has_many what?"
    class_option :orm, :type => :string, :default => "active_record"

    def udpate_model
      inject_into_file(model_path, :after => first_class_name_line) do
        "  has_many :#{belonging.pluralize}, dependent: :destroy\n"
      end
            
      inject_into_file(model_path, :after => private_api_accessible) do
        "    template.add :#{belonging.pluralize},   :template => :public\n"
      end      
    end

    def update_view_file
      tab_end     = "  </ul><!-- end-of-tabs -->"
      content_end = "  </div><!-- end-of-contents -->"       

      inject_into_file(show_path, :before => tab_end) do
        "    <li><a href=\"##{belonging}\" data-toggle=\"tab\">#{belonging.pluralize.humanize}</a></li>\n"
      end
      
      inject_into_file(show_path, :before => content_end) do
        "    <div class=\"tab-pane\" id=\"#{belonging}\"> <%= render partial: '/#{belonging.pluralize}/list', locals:{#{belonging.pluralize}:@#{file_name}.#{belonging.pluralize}, as:'#{belonging}', owner:@#{file_name}, show_when_empty:true, show_pages:true, show_title:false, show_new:false} %> </div>\n"
      end
    end
    
    def model_path
      File.join("app", "models", "#{file_name}.rb")
    end
    
    def show_path
      File.join("app/views", file_name.pluralize, "show.html.erb")
    end
    
    def first_class_name_line
      if options.orm == :active_record
        /class #{class_name.camelize}\n|class #{class_name.camelize} .*\n|class #{class_name.demodulize.camelize}\n|class #{class_name.demodulize.camelize} .*\n/
      else
        /include Mongoid::Document\n|include Mongoid::Document .*\n/
      end
    end
    
    def private_api_accessible
      /api_accessible.*:private.*\n/
    end
    
end
