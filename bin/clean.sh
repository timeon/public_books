#!/bin/sh

rails g scaffold category         name description --force
rails g scaffold keyword          category:references name --force

rails g scaffold policy           name description --force
rails g scaffold color            name policy:references --force

rails g scaffold publisher        name email address phone --force
rails g scaffold operating_system name --force

rails g scaffold device           user:references name description form_factor os_name os_version manufacturer model sn rooted:boolean jail_broken:boolean --force
rails g scaffold app              publisher:references color:references name label package version_name version_code:integer min_sdk_version:integer target_os_version minimum_os_version url_schemes installer_fingerprint --force
rails g scaffold feature          app:references  name --force
rails g scaffold permission       app:references  name --force
rails g scaffold component        app:references  name kind label description permission --force

rails g scaffold meta             component:references name resource value --force
rails g scaffold intent_action    component:references name --force
rails g scaffold intent_category  component:references name --force
rails g scaffold intent_data      component:references scheme host port path path_prefix path_pattern mime_type --force

rails g scaffold property         resource:references{polymorphic} name value --force

rails g many app feature
rails g many app permission
rails g many app component
rails g many app property
rails g many app intent_action
rails g many app intent_category
rails g many app intent_data

rails g many component meta
rails g many component intent_action
rails g many component intent_category
rails g many component intent_data

rails g many user      device
rails g many user 	   property

rails g many color app
rails g many operating_system app
rails g many publisher app
rails g many publisher property

rails g many device    property

rails g many category  keyword
rails g many category  app

rails g fix everything

rm -rf db/migrate/*
rm -rf app/models/*
rm -rf app/controllers/apps_controller.rb
rm app/views/properties/_form.html.erb
svn update

gerd

    