class Organisation < ActiveRecord::Base
  has_many :organisation_users
  has_many :users, :through => :organisation_users
  has_many :folios

  attr_accessible :name, :website

  validates :name, :presence => true
end
