# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

#Dir[File.dirname(__FILE__) + '/seeds/*.rb'].each {|file| require file }

#Dir[File.dirname(__FILE__) + '/seeds/*.rb'].glob('**/*').map { |file| [file.count("/"), file] }.sort.map { |file| file[1] }.each { |file| puts file }

files = Dir[File.dirname(__FILE__) + '/seeds/*.rb']
files = files.map { |file| [file.count("/"), file] }
files = files.sort.map { |file| file[1] }
files.each do |file|
  puts file
  require file  
end