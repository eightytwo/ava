class Folio < ActiveRecord::Base
  belongs_to :organisation
  has_many :folio_users
  has_many :users, :through => :folio_users

  attr_accessible :description, :name
end
