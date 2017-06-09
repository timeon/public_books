json.array!(@audits) do |audit|
  json.extract! audit, :id, :auditable_id, :auditable_type, :associated_id, :associated_type, :user_id, :user_type, :username, :action, :audited_changes, :version, :comment, :remote_address, :request_uuid
  json.url audit_url(audit, format: :json)
end
