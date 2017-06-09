class FamilyMailer < ActionMailer::Base

  def setup(family)
    @admin  = false
    @family = family
    @url    = family_url(family, key:family.key, host:(Rails.env.development? ? 'http://192.168.1.149:5000' : 'www.FreeFuyin.com'))
    @emails =  @family.people.where(relation:['self','spouse']).pluck(:email).join(",")
  end

  def updated_family(family)
    setup(family)

    if @emails
      mail(:from     => "Bryan Wang<timeon@gmai.com>",
           :to       => @emails,
           :reply_to => "timeon@gmail.com",
           :subject  => "中区主恩堂#{DateTime.now.year}通讯录更新 - Thank you for updating" )
    end
  end

  def check_family(family)
    setup(family)

    if @emails
      mail(:from     => "Bryan Wang<timeon@gmai.com>",
           :to       => @emails,
           :reply_to => "timeon@gmail.com",
           :subject  => "中区主恩堂#{DateTime.now.year}通讯录更新 - Please verify your family" )
    end
  end

end


