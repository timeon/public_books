json.array!(@authors) do |author|
  json.extract! author, :id, :name, :english_name, :description, :photo
  json.url author_url(author, format: :json)
end
