json.array!(@people) do |person|
  json.extract! person, :id, :family_id, :relation, :first_name, :last_name, :chinese_name, :email, :phone, :phone_ext
  json.url person_url(person, format: :json)
end
