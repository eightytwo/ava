class Folio < ActiveRecord::Base
  belongs_to :organisation
  has_many :folio_users
  has_many :users, :through => :folio_users
  has_many :rounds

  attr_accessible :description, :name, :organisation_id, :organisation
  accepts_nested_attributes_for :organisation

  validates :name, :presence => true
  validates :description, :presence => true
  validates :organisation, :presence => true
end
