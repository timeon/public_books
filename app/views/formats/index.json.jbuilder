json.array!(@formats) do |format|
  json.extract! format, :id, :name, :media_id
  json.url format_url(format, format: :json)
end
