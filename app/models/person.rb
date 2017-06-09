class Person < ActiveRecord::Base

  RELATIONS = ["self", "spouse", "brother", "sister", "child", "mom", "dad", "grandma", "grandpa", "uncle", "aunt", "nephew", "niece",  "grandchild"]
  belongs_to :family

  self.per_page = 20
  
  
  def to_s
    first_name
  end    
  

  def email_font_size
    if phone.present? and email and email.length > 20
      em = (40.0 - email.length) / 200.0 * 4 + 0.6
    else
      em = 1
    end
  end

end

