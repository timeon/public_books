Contact.all.each do |contact|

    next

    puts contact.id.to_s + ": " +  (contact.adult_1_chinese_name || contact.adult_1_first_name)

	family = Family.new(phone: contact.home_phone ,
					    street:contact.street_no_and_name ,
					    city:  contact.city ,
					    state: contact.state,
					    zip:   contact.zip,
					    country: contact.country,
					    verified:contact.verified ,
					    disabled:contact.disabled ,
					    one_more_year:contact.one_more_year,
					    key: contact.key,
					    note:contact.note)

    if contact.photo_file_name
      photo_file = Rails.root.to_s + '/public/system/photos/' + contact.id.to_s + '/original/' + contact.photo_file_name
      family.photo = File.open(photo_file)
    end

	family.save


	person = Person.new(family:family, 
	                    relation: 'self',
	                    first_name:   contact.adult_1_first_name,
	                    last_name:    contact.adult_1_last_name,
	                    chinese_name: contact.adult_1_chinese_name,
	                    email:  	  contact.adult_1_email,
	                    phone:        contact.adult_1_phone,
	                    phone_ext:    contact.adult_1_phone_ext)
	person.save


	if ! (contact.adult_2_chinese_name.blank? and contact.adult_2_first_name.blank? )
		person = Person.new(family:family, 
		                    relation: 'spouse',
		                    first_name:   contact.adult_2_first_name,
		                    last_name:    contact.adult_2_last_name,
		                    chinese_name: contact.adult_2_chinese_name,
		                    email:  contact.adult_2_email,
		                    phone:  contact.adult_2_phone,
		                    phone_ext:  contact.adult_2_phone_ext)
		person.save
	end

	if ! (contact.child_1_chinese_name.blank? and contact.child_1_first_name.blank?) 
		person = Person.new(family:family, 
	                    relation: contact.child_1_relation,
	                    first_name:   contact.child_1_first_name,
	                    last_name:    contact.child_1_last_name,
	                    chinese_name: contact.child_1_chinese_name)	
		person.save
	end	

	if ! (contact.child_2_chinese_name.blank? and contact.child_2_first_name.blank?) 
		person = Person.new(family:family, 
	                    relation: contact.child_2_relation,
	                    first_name:   contact.child_2_first_name,
	                    last_name:    contact.child_2_last_name,
	                    chinese_name: contact.child_2_chinese_name)	
		person.save
	end	

	if ! (contact.child_3_chinese_name.blank? and contact.child_3_first_name.blank?) 
		person = Person.new(family:family, 
	                    relation: contact.child_3_relation,
	                    first_name:   contact.child_3_first_name,
	                    last_name:    contact.child_3_last_name,
	                    chinese_name: contact.child_3_chinese_name)	
		person.save
	end	

	if ! (contact.child_4_chinese_name.blank? and contact.child_4_first_name.blank?) 
		person = Person.new(family:family, 
	                    relation: contact.child_4_relation,
	                    first_name:   contact.child_4_first_name,
	                    last_name:    contact.child_4_last_name,
	                    chinese_name: contact.child_4_chinese_name)	
		person.save
	end	

	if ! (contact.child_5_chinese_name.blank? and contact.child_5_first_name.blank?) 
		person = Person.new(family:family, 
	                    relation: contact.child_5_relation,
	                    first_name:   contact.child_5_first_name,
	                    last_name:    contact.child_5_last_name,
	                    chinese_name: contact.child_5_chinese_name)	
		person.save
	end	

end

