#!/bin/bash

project_name=$1

pushd `dirname ${0}\..\..` > /dev/null
SCRIPTPATH=`pwd -P`
popd > /dev/null

base_dir="${SCRIPTPATH}/../"

echo "base dir: ${base_dir}"
echo "project : ${project_name}"

rm -rf new $project_name
rails new $project_name
cd $project_name

cp -R $base_dir/lib/generators lib/
cp -R $base_dir/lib/templates/ lib/
cp $base_dir/config/initializers/generators.rb config/initializers/
cp $base_dir/config/initializers/simple_form* config/initializers/
cp $base_dir/app/assets/javascripts/application.js app/assets/javascripts/
cp $base_dir/app/assets/stylesheets/application.css.scss app/assets/stylesheets/
cp $base_dir/app/assets/stylesheets/bootstrap_and_overrides.css.scss app/assets/stylesheets/
cp $base_dir/app/views/layouts/application.html.erb app/views/layouts/
cp $base_dir/app/views/layouts/_* app/views/layouts/
cp $base_dir/Gemfile .
cp $base_dir/db/seeds.rb db/
cp $base_dir/config/application.yml config/
cp -R $base_dir/db/seeds db/
cp -R $base_dir/app/assets/images/* app/assets/images

bundle update

rails g scaffold user           first_name last_name display_name gender phone email --force
bundle exec rake db:create
bundle exec rake db:migrate
 
rails generate devise:install
rails g migration RemoveEmailFromUser email:string # devise will try to add it
rails g devise user  --force

rails g devise_invitable:install
rails g devise_invitable user

rails g devise:views confirmable

rails g scaffold role           name resource:references{polymorphic}
rm    app/models/role.rb    
rm    spec/factories/roles.rb   
# delete this existing migration file
find db/migrate/ -name *[0-9]_create_roles.rb -exec rm {} \;
# generate rolify model and migration file
rails g rolify Role User
# add the missing .rb extention in the genrated migration file
find db/migrate/ -name *[0-9]_rolify_create_roles -exec sh -c 'mv "$1" "${1}.rb"' _ {} \;
bundle exec rake db:migrate

cp $base_dir/app/models/ability.rb app/models/

rails g scaffold setting    var value:text  thing_type thing_id:integer  --force
rails g settings setting    --force
cp $base_dir/app/controllers/settings_controller.rb app/controllers/
cp $base_dir/app/views/settings/index.html.erb      app/views/settings/
cp $base_dir/app/views/settings/_form.html.erb      app/views/settings/

rails g rails_settings_ui:install
cp $base_dir/app/helpers/rails_settings_ui          app/helpers
cp $base_dir/app/views/rails_settings_ui            app/views
cp $base_dir/app/controllers/rails_settings_ui      app/controllers

rails g scaffold page name content:text position order:integer visible:boolean
cp $base_dir/app/controllers/pages_controller.rb app/controllers/
cp -R $base_dir/app/views/pages/db.html.erb      app/views/pages

cp $base_dir/app/controllers/tokens_controller.rb app/controllers/
cp $base_dir/app/controllers/application_controller.rb app/controllers/application_controller.rb.ref

# Learning Genie
: '
rails g scaffold chain          name description --force
rails g scaffold school         name description chain:references  --force

rails g scaffold room           name description school:references stage children_capicity:integer teacher_capicity:integer --force
rails g scaffold child          first_name last_name display_name gender date_of_birth:date description --force
rails g scaffold enrollment     child:references room:references enrolled_on:date graduated_on:date status sunday monday tuesday wednesday thursday friday saturday --force
rails g scaffold attendance     child:references room:references absent_note:references check_in_teacher:references check_in_guardian:references check_out_teacher:references check_out_guardian:references check_in_at:datetime check_out_at:datetime --force
rails g scaffold health_concern child:references name status detail started_on:date ended_on:date life_threatening:boolean --force
rails g scaffold allergy        child:references name status detail started_on:date ended_on:date life_threatening:boolean --force
rails g scaffold injury         child:references name status detail started_on:date ended_on:date life_threatening:boolean --force
rails g scaffold immunization   child:references name completed_shots:integer total_shots:integer detail last_on:date next_on:date --force

rails g scaffold note           room:references title type description show_to_guardian:boolean started_at:datetime ended_at:datetime recorded_at:datetime --force
rails g scaffold property       note:references name value --force
rails g scaffold report         child:references begins_at:datetime ends_at:datetime --force
rails g scaffold relation       child:references user:references name --force
rails g scaffold domain         name code icon --force
rails g scaffold measure        domain:references name code  --force

rails g model notes_reports   note:references  report:references --timestamps false --force
rails g model children_notes  child:references note:references   --timestamps false --force

rails g many  chain   school
rails g many  school  room
rails g many  user  relation
rails g many  child   relation
rails g many  child   enrollment
rails g many  child   attendance
rails g many  child   health_concern
rails g many  child   allergy
rails g many  child   injury
rails g many  child   immunization
rails g many  child   report
rails g many  child   note
rails g many  report  note
rails g many  note    property
rails g many  domain  measure

#rails g paperclip user   avatar
#rails g paperclip child  avatar
#rails g paperclip chain  logo
#rails g paperclip school logo
#rails g paperclip note   image
'

# App list
: '
rails g scaffold app name description package version_code:integer version_name min_sdk_version:integer label hash
  
rails g scaffold feature          app:references name
rails g scaffold permission       app:references name
rails g scaffold resource_string  app:references name value
rails g scaffold dex_string       app:references name value
rails g scaffold component        app:references name type label description permission

rails g scaffold intent_filter    component:references 
rails g scaffold intent_action    intent_filter:references name

rails g scaffold property         resource:references{polymorphic} name value 

rails g many app feature
rails g many app permission
rails g many app resource_string
rails g many app dex_string
rails g many app component

rails g many component intent_filter
rails g many intent_filter intent_action
rails g many intent_filter property
'

# chat keep
: '
rails g scaffold person name gender nickname group_nickname signature country city 
rails g scaffold message person:references body:text
rails g scaffold chat name u:references 
rails g many chat message

bundle exec rake acts_as_taggable_on_engine:install:migrations
bundle exec rake db:migrate

bundle exec rake db:seed

#rails g scaffold address        line_1 line_2 city state country zip_code description addressable:references{polymorphic} --force

rails g fix everything


#manual steps
# uncomment devise confirmable and lockable code in migration
# copy block to user.rb

  acts_as_tagger
  acts_as_token_authenticatable
  
  devise :invitable, 
         :database_authenticatable, 
         :registerable, 
         :confirmable,
         :recoverable,
         :rememberable, 
         :trackable,
         :validatable,
         :lockable,
         :timeoutable,
         :omniauthable
         
# add to config\environments\development.rb
#   config.action_mailer.default_url_options = { :host => 'localhost:3000' }

mkdir public/images
rake erd filetype=png filename=public/images/details title="Detailed diagram" attributes=primary_keys,foreign_keys,timestamps,content
rake erd filetype=png filename=public/images/brief title="Brief diagram" attributes=false
rake erd filetype=pdf filename=public/details title="Detailed diagram" attributes=primary_keys,foreign_keys,timestamps,content
rake erd filetype=pdf filename=public/brief title="Brief diagram" attributes=false
'

