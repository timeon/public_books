ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
#  tls:                   true,
  address:               'smtp.gmail.com',
  port:                  587,
  domain:                'FreeFuyin.com',
  authentication:        :plain,
  user_name:             'notifications@FreeFuyin.com',
  password:              'ffmail#1!',
  enable_starttls_auto:  true  }

require 'development_mail_interceptor' #add this line
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if  Rails.env.development?
