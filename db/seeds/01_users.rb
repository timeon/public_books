puts 'DEFAULT USERS'

User.add ENV['ADMIN_NAME'].dup, ENV['ADMIN_EMAIL'].dup,   :admin

