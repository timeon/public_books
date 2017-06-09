json.array!(@lessons) do |lesson|
  json.extract! lesson, :course_id, :name, :description, :body, :image
end