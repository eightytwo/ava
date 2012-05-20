class Organisation < ActiveRecord::Base
  has_many :organisation_users
  has_many :users, :through => :organisation_users

  attr_accessible :name, :website
end
