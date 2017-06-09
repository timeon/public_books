json.array!(@properties) do |property|
  json.extract! property, :id, :resource_id, :resource_type, :name, :value
  json.url property_url(property, format: :json)
end
