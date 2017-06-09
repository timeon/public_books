json.array!(@media) do |medium|
  json.extract! medium, :id, :name, :icon
  json.url medium_url(medium, format: :json)
end
