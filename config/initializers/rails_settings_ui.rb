require 'rails-settings-ui'

#= Application-specific
#
# # You can specify a controller for RailsSettingsUi::ApplicationController to inherit from:
# RailsSettingsUi.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'
#
# # Render RailsSettingsUi inside a custom layout (set to 'application' to use app layout, default is RailsSettingsUi's own layout)
# RailsSettingsUi::ApplicationController.layout 'admin'


Rails.application.config.to_prepare do
  # Use admin layout:
  RailsSettingsUi::ApplicationController.module_eval do
    layout 'application'
  end
  # If you are using a custom layout, you will want to make app routes available to rails-setting-ui:
  RailsSettingsUi.inline_main_app_routes!
end


RailsSettingsUi.setup do |config|
  config.ignored_settings = [:company_name] # Settings not displayed in the interface
  config.settings_class = "Setting" # Customize settings class name
end

