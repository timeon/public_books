class RailsSettingsUi::SettingsController < RailsSettingsUi::ApplicationController

  load_and_authorize_resource
  before_filter :collection
  before_filter :cast_settings_params, only: :update_all

  def index
#debugger      
  end

  def update_all
    if @casted_settings[:errors].any?
      render :index,  layout: "application"
    else
      @casted_settings.map do |setting| 
        RailsSettingsUi.settings_klass[setting[0]] = setting[1] if setting[0] != "errors"
      end   
      redirect_to [:settings]
    end
  end

  private

  def collection
    all_settings = RailsSettingsUi.settings_klass.defaults.merge(RailsSettingsUi.settings_klass.get_all)
    all_settings_without_ignored = all_settings.reject{ |name, description| RailsSettingsUi.ignored_settings.include?(name.to_sym) }
    @settings = Hash[all_settings_without_ignored]
  end

  def cast_settings_params
    @casted_settings = RailsSettingsUi::TypeConverter.cast(params["settings"])
  end
end
