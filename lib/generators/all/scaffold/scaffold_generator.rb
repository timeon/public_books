require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'

module All # :nodoc:
  module Generators # :nodoc:
    class ScaffoldGenerator < Rails::Generators::NamedBase # :nodoc:
      include Rails::Generators::ResourceHelpers

      source_root File.join(Rails.root, 'lib', 'templates', 'erb', 'scaffold', File::SEPARATOR)
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def copy_view_files
        empty_directory File.join("app/views", controller_file_path)

        available_views.each do |view|
          template view, File.join("app/views", controller_file_path, view)
          template view, File.join("app/views", controller_file_path,  "_#{singular_table_name}.html.erb") if view == "_row.html.erb"
        end
        
        row_file = File.join("app/views", controller_file_path, "_row.html.erb")
        resource_name_file = File.join("app/views", controller_file_path, "_#{singular_table_name}.html.erb")
      end

      def add_attachments
        attributes.each do |attribute|
          if attribute.type == :attachment
            add_attachment_to_model attribute.name
            
            #generate "paperclip", "#{singular_table_name} #{attribute.name}"

            available_views.each do |view|
              gsub_file File.join("app/views", controller_file_path, view), 
                        "#{singular_table_name}.#{attribute.name}",  
                        "link_to image_tag(#{singular_table_name}.#{attribute.name}.url(:thumb)), #{singular_table_name}.#{attribute.name}.url"
            end
          end
        end  

      end  

      def update_controller
        file = File.join("app", "controllers", "#{plural_table_name}_controller.rb")
        
        if File.exist? file
          inject_into_file  file, "  load_and_authorize_resource\n", :after => /ApplicationController.*\n/
          inject_into_file  file, ", :json, :xml",                   :after => 'respond_to :html'
          gsub_file         file, ".all", ".paginate(:page => params[:page], :per_page => params[:per_page])"
        end
      end  
 
   protected

      def add_attachment_to_model(name)
        prepend_model "validates_attachment_content_type :#{name}, content_type: /\\Aimage\\/.*\\Z/, size:{in: 0..10.megabytes }"
        prepend_model "has_attached_file :#{name}, styles:{medium: '300x300>', thumb: '100x100>' , icon: '50x50>' }, default_url: '/assets/:style/missing_#{name}.png'\n"
      end

      def prepend_model(line)
        file = File.join("app", "models", "#{singular_table_name}.rb")
        if File.exist?(file) and File.file?(file)
          inject_into_file  file, "  #{line}\n", :after => /ActiveRecord::Base.*\n/
        end  
      end
      
      def append_model(line)
        file = File.join("app", "models", "#{singular_table_name}.rb")
        if File.exist?(file) and File.file?(file)
          inject_into_file  file, "  #{line}\n", :before => /^end/
        end  
      end
    
      def append_route(line)
        file = File.join("config/routes.rb")
        inject_into_file  file, "  #{line}\n", :before => /^end/
      end
    
      def append_api(line, force=true)
        file = File.join("config/routes.rb")
        inject_into_file     file, "    #{line}\n", :before => /^  end # api/, :force => true
      end
    
      def available_views
        # use all template files contained in source_root ie 'lib/templates/erb/scaffold/**/*'
        base = self.class.source_root
        base_len = base.length
        Dir[File.join(base, '**', '*')].select { |f| File.file?(f) }.map{|f| f[base_len..-1]}
      end

      def attributes_list_with_timestamps
        attributes_list(attributes_names + %w(created_at updated_at))
      end

      def attributes_list(attributes = attributes_names)
        if self.attributes.any? {|attr| attr.name == 'password' && attr.type == :digest}
          attributes = attributes.reject {|name| %w(password password_confirmation).include? name}
        end

        attributes.map { |a| ":#{a}"} * ', '
      end      
      
=begin

      def attach
        attachable = attachables.find {|x| x[:name] == singular_table_name }
        if attachable 
          add_attachment_to_model(attachable[:attachment])
          add_attachment_to_views(singular_table_name, attachable[:attachment])
          add_attachment_to_controller(singular_table_name, attachable[:attachment])
          generate "paperclip", "#{singular_table_name} #{attachable[:attachment]}"
        end
      end  

      def sample_value(a)
        if a.type == :integer
          10
        elsif  a.type == :string or a.type == :text
          "\"a #{a.name }\""
        elsif  a.type == :boolean
          true
        elsif  a.type == :date
          "\"#{Date.today}\""
        elsif  a.type == :datetime
          "\"#{DateTime.now}\""
        else
          '""'
        end
      end
      
      def add_api_taster_routes
        
        append_route   "root :to => 'chains#index'\n"

        append_route   "mount ApiTaster::Engine => '/api_taster'\n"
        
        append_route   "ApiTaster.global_params = {"
        append_route   "  :version    => 1,"
        append_route   "  :format     => 'json',"
        append_route   "  :user_email => '',"
        append_route   "  :user_token => ''"
        append_route   "}\n"

        append_route   "ApiTaster.routes do\n"
        append_route   "end # api\n"

        append_api     "desc 'Get a __list__ of #{plural_table_name }'"
        append_api     "get '/#{plural_table_name }'\n"
      
        append_api     "desc 'Add a #{singular_table_name }'"
        append_api     "post '/#{plural_table_name }', {"
        append_api     "  :#{singular_table_name } => {"
        attributes.each do |a|
          append_api   "    :#{a.name } => #{sample_value(a)},"
        end
        append_api     "  }"
        append_api     "}\n"
      
        append_api     "desc 'Get a #{singular_table_name }'"
        append_api     "get '/#{plural_table_name }/:id', {"
        append_api     "  :id => 1"    
        append_api     "}\n"
      
        append_api     "desc 'Update a #{singular_table_name }'"
        append_api     "put '/#{plural_table_name }/:id', {"
        append_api     "  :id => 1, :#{singular_table_name } => {"
        attributes.each do |a|
          append_api   "    :#{a.name } => #{sample_value(a)},"
        end
        append_api     "  }"
        append_api     "}\n"
      
        append_api     "desc 'Delete a #{singular_table_name }'"
        append_api     "delete '/#{plural_table_name }/:id', {"
        append_api     "  :id => 1"
        append_api     "}\n"
      end


      def attachables
        att = []
        att << {name: "chain",    attachment: "logo"}
        att << {name: "school",   attachment: "logo"}
        att << {name: "user",     attachment: "avatar"}
        att << {name: "person",   attachment: "avatar"}
        att << {name: "child",    attachment: "avatar"}
        att << {name: "screen",   attachment: "image"}
        att << {name: "camera",   attachment: "image"}
        att << {name: "photo",    attachment: "image"}
        att << {name: "app",      attachment: "installer"}
        att << {name: "app",      attachment: "icon"}
        att << {name: "device",   attachment: "image"}
        att << {name: "message",  attachment: "image"}
        att << {name: "log",      attachment: "file"}
        att << {name: "sdk",      attachment: "file"}
        att << {name: "product",  attachment: "image"}
        att << {name: "community",attachment: "avatar"}
      end

      def add_attachment_to_controller(attachable, name)
        file = File.join("app", "controllers", "#{plural_table_name}_controller.rb")
        inject_into_file  file, ", :#{name}", :after => /permit\(:[a-z_]*/
      end  
    
      def add_attachment_to_views(attachable, name)
        file = File.join("app", "views", "#{plural_table_name}", "_form.html.erb")
        inject_into_file  file, "      <%= f.input :#{name}%>\n", :after => /@return_path\) %>.*\n/

        file = File.join("app", "views", "#{plural_table_name}", "_show.html.erb")
        inject_into_file  file, "    <dd><%= link_to image_tag(#{attachable}.#{name}.url(:thumb)), #{attachable} %></dd>\n", :after => /<dl class="dl-horizontal">.*\n/
        inject_into_file  file, "    <dt>#{name}</dt>\n", :after => /<dl class="dl-horizontal">\n/

        file = File.join("app", "views", "#{plural_table_name}", "_header.html.erb")
        inject_into_file  file, "    <th>#{name}</th>\n", :after => /<tr>.*\n/


        file = File.join("app", "views", "#{plural_table_name}", "_row.html.erb")
        inject_into_file  file, "    <td><%= link_to image_tag(#{attachable}.#{name}.url(:icon)), #{attachable} %></td>\n", :after => /<tr>.*\n/
      end
      
=end      
          
    end
  end
end

