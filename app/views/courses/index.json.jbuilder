json.array!(@courses) do |course|
  json.extract! course, :id, :category_id, :name, :description, :icon
  json.url course_url(course, format: :json)
end
