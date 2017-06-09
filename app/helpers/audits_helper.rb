module AuditsHelper
  def changes audited_changes
    audited_changes[4..-1].gsub("\n", "<br>")
  end

  def data_type(audit)
    if audit.auditable_type == "RailsSettings::Settings"
      data_type = "setting"  
    else
      data_type = audit.auditable_type.downcase  
    end    
  end

  def data_name(audit)  
    "#{t data_type(audit)}:#{audit.auditable_id}"    
  end

  def data_url(audit)  
    "#{data_type(audit).pluralize}/#{audit.auditable_id}"    
  end

end
