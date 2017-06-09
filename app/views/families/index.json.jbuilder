json.array!(@families) do |family|
  json.extract! family, :id, :user_id, :phone, :street, :city, :state, :zip, :country, :photo, :verified, :disabled, :one_more_year, :key, :note
  json.url family_url(family, format: :json)
end
