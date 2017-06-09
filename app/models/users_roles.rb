class UsersRoles < ActiveRecord::Base
  audited
  belongs_to :user
  belongs_to :role
end

