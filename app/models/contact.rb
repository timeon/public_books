class Contact < ActiveRecord::Base
  has_attached_file :photo, styles:{medium: '300x300>', thumb: '100x100>' , icon: '50x50>' }, default_url: '/assets/:style/missing_photo.png'

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/, size:{in: 0..10.megabytes }

  validates_presence_of :adult_1_first_name
  validates_presence_of :adult_1_last_name

  validates_presence_of :street_no_and_name
  validates_presence_of :city
  validates_presence_of :state

  validates_presence_of :zip

  validates :adult_1_chinese_name, :uniqueness => { :scope => :adult_1_last_name}

  RELATIONS = ["child", "mom", "dad", "grandma", "grandpa", "uncle", "aunt", "grandson", "granddaugher"]
  COUNTRIES = ["US", "China", "Others"]

  belongs_to :user

  self.per_page = 20
  

  def to_s
    display = "\n===============================================\n"
    display += "adult 1: #{adult_1_chinese_name}|#{adult_1_first_name}|#{adult_1_last_name}|#{adult_1_email}|#{adult_1_phone}|\n"
    display += "adult 2: #{adult_2_chinese_name}|#{adult_2_first_name}|#{adult_2_last_name}|#{adult_2_email}|#{adult_2_phone}|\n" if adult_2?
    display += "addr   : #{street_no_and_name}|#{city}, #{state} #{zip}|#{home_phone}|\n"
    display += "child 1: #{child_1_first_name}|#{child_1_last_name}|\n"  if child_1?
    display += "child 2: #{child_2_first_name}|#{child_2_last_name}|\n"  if child_2?
    display += "child 3: #{child_3_first_name}|#{child_3_last_name}|\n"  if child_3?
    display += "child 4: #{child_4_first_name}|#{child_4_last_name}|\n"  if child_4?
    display += "child 5: #{child_4_first_name}|#{child_5_last_name}|\n"  if child_5?
    display += "----------------------------------------------\n"
  end

  def chinese_names
   names = adult_1_chinese_name || adult_1_first_name
   if names and adult_2?
     names += ", "
     names += adult_2_chinese_name || adult_2_first_name || ""
   end
   names
  end

  def english_names
   names = adult_1_last_name.upcase + ", " + adult_1_first_name
   if adult_2?
     names += " & " + adult_2_first_name
     if(adult_1_last_name != adult_2_last_name)
       names += " " + adult_2_last_name.upcase;
     end
   end
   names
  end

  def names
    if adult_1_first_name and adult_2_first_name
      names = "#{adult_1_first_name} and #{adult_2_first_name}"
    elsif adult_1_email
      names = "#{adult_1_first_name}"
    elsif adult_2_email
      names = "#{adult_2_first_name}"
    else
      names = nil
    end
  end



  def emails
    if !adult_1_email.blank? and !adult_2_email.blank?
      emails = "#{adult_1_first_name} #{adult_1_last_name}<#{adult_1_email}>, #{adult_2_first_name} #{adult_2_last_name} <#{adult_2_email}>"
    elsif !adult_1_email.blank?
      emails = "#{adult_1_first_name}  #{adult_1_last_name}<#{adult_1_email}>"
    elsif !adult_2_email.blank?
      emails = "#{adult_2_first_name}  #{adult_2_last_name}<#{adult_2_email}>"
    else
      emails = nil
    end
  end

  
  def before_save
    if key == nil
      self.key = (rand * 100000000000).round
    end

    self.home_phone    = self.home_phone.tr("^0-9", "")    if home_phone and us?
    self.adult_1_phone = self.adult_1_phone.tr("^0-9", "") if adult_1_phone and us?
    self.adult_2_phone = self.adult_2_phone.tr("^0-9", "") if adult_2_phone and us?

    self.home_phone    = nil if home_phone    and home_phone.length    == 0
    self.adult_1_phone = nil if adult_1_phone and adult_1_phone.length == 0
    self.adult_2_phone = nil if adult_2_phone and adult_2_phone.length == 0

    self.adult_1_first_name = self.adult_1_first_name.tr("^A-Za-z", "").capitalize if adult_1_first_name
    self.adult_1_last_name  = self.adult_1_last_name.tr("^A-Za-z",  "").capitalize if adult_1_last_name

    self.adult_2_first_name = self.adult_2_first_name.tr("^A-Za-z", "").capitalize if adult_2_first_name
    self.adult_2_last_name  = self.adult_2_last_name.tr("^A-Za-z",  "").capitalize if adult_2_last_name

    self.child_1_first_name = self.child_1_first_name.tr("^A-Za-z", "").capitalize if child_1_first_name
    self.child_1_last_name  = self.child_1_last_name.tr("^A-Za-z",  "").capitalize if child_1_last_name

    self.child_2_first_name = self.child_2_first_name.tr("^A-Za-z", "").capitalize if child_2_first_name
    self.child_2_last_name  = self.child_2_last_name.tr("^A-Za-z",  "").capitalize if child_2_last_name

    self.child_3_first_name = self.child_3_first_name.tr("^A-Za-z", "").capitalize if child_3_first_name
    self.child_3_last_name  = self.child_3_last_name.tr("^A-Za-z",  "").capitalize if child_3_last_name

    self.child_4_first_name = self.child_4_first_name.tr("^A-Za-z", "").capitalize if child_4_first_name
    self.child_4_last_name  = self.child_4_last_name.tr("^A-Za-z",  "").capitalize if child_4_last_name

    self.child_5_first_name = self.child_5_first_name.tr("^A-Za-z", "").capitalize if child_5_first_name
    self.child_5_last_name  = self.child_5_last_name.tr("^A-Za-z",  "").capitalize if child_5_last_name

    self.adult_1_first_name = nil if adult_1_first_name and adult_1_first_name.length == 0
    self.adult_2_first_name = nil if adult_2_first_name and adult_2_first_name.length == 0

    self.adult_1_last_name = nil if adult_1_last_name and adult_1_last_name.length == 0
    self.adult_2_last_name = nil if adult_2_last_name and adult_2_last_name.length == 0


    self.adult_1_chinese_name = nil if adult_1_chinese_name and adult_1_chinese_name.length == 0
    self.adult_2_chinese_name = nil if adult_2_chinese_name and adult_2_chinese_name.length == 0

    self.child_1_first_name = nil if child_1_first_name and child_1_first_name.length == 0
    self.child_2_first_name = nil if child_2_first_name and child_2_first_name.length == 0
    self.child_3_first_name = nil if child_3_first_name and child_3_first_name.length == 0
    self.child_4_first_name = nil if child_4_first_name and child_4_first_name.length == 0
    self.child_5_first_name = nil if child_5_first_name and child_5_first_name.length == 0

    self.child_1_last_name = nil if child_1_last_name and child_1_last_name.length == 0
    self.child_2_last_name = nil if child_2_last_name and child_2_last_name.length == 0
    self.child_3_last_name = nil if child_3_last_name and child_3_last_name.length == 0
    self.child_4_last_name = nil if child_4_last_name and child_4_last_name.length == 0
    self.child_5_last_name = nil if child_5_last_name and child_5_last_name.length == 0

    self.child_1_chinese_name = nil if child_1_chinese_name and child_1_chinese_name.length == 0
    self.child_2_chinese_name = nil if child_2_chinese_name and child_2_chinese_name.length == 0
    self.child_3_chinese_name = nil if child_3_chinese_name and child_3_chinese_name.length == 0
    self.child_4_chinese_name = nil if child_4_chinese_name and child_4_chinese_name.length == 0
    self.child_5_chinese_name = nil if child_5_chinese_name and child_5_chinese_name.length == 0
  end


  def adult_2?
    !adult_2_first_name.blank?
  end

  def child_1?
    !child_1_first_name.blank? or !child_1_chinese_name.blank?
  end

  def child_2?
    !child_2_first_name.blank? or !child_2_chinese_name.blank?
  end

  def child_3?
    !child_3_first_name.blank? or !child_3_chinese_name.blank?
  end

  def child_4?
    !child_4_first_name.blank? or !child_4_chinese_name.blank?
  end

  def child_5?
    !child_5_first_name.blank? or !child_5_chinese_name.blank?
  end

  def us?
    country == "US"
  end



  def children
   children = ""

   if child_1?
     if child_1_relation != "child"
       children += "#{child_1_first_name} #{child_1_last_name} #{child_1_chinese_name}(#{child_1_relation})"
     else
       children += child_1_first_name || ""
       children += " " + child_1_last_name  if child_1_last_name and adult_1_last_name and child_1_last_name != adult_1_last_name
     end
   end

   if child_2?
     children += ", "
     if child_2_relation != "child"
       children += "#{child_2_first_name} #{child_2_last_name} #{child_2_chinese_name}(#{child_2_relation})"
     else
       children += child_2_first_name || ""
       children += " " + child_2_last_name  if child_2_last_name and adult_1_last_name and child_2_last_name != adult_1_last_name
     end
   end

   if child_3?
     children += ", "
     if child_3_relation != "child"
       children += "#{child_3_first_name} #{child_3_last_name} #{child_3_chinese_name}(#{child_3_relation})"
     else
       children += child_3_first_name || ""
       children += " " + child_3_last_name  if child_3_last_name and adult_1_last_name and child_3_last_name != adult_1_last_name
     end
   end

   if child_4?
     children += ", "
     if child_4_relation != "child"
       children += "#{child_4_first_name} #{child_4_last_name} #{child_4_chinese_name}(#{child_4_relation})"
     else
       children += child_4_first_name || ""
       children += " " + child_4_last_name  if child_4_last_name and adult_1_last_name and child_4_last_name != adult_1_last_name
     end
   end

   if child_5?
     children += ", "
     if child_5_relation != "child"
       children += "#{child_5_first_name} #{child_5_last_name} #{child_5_chinese_name}(#{child_5_relation})"
     else
       children += child_5_first_name || ""
       children += " " + child_5_last_name  if child_5_last_name and adult_1_last_name and child_5_last_name != adult_1_last_name
     end
   end

   return children
  end
  
end

