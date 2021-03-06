class Folio < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'FolioAuthorizer'

  belongs_to :organisation
  has_many :folio_users, dependent: :delete_all
  has_many :users, through: :folio_users
  has_many :rounds, dependent: :delete_all

  attr_accessible :description, :name, :organisation_id

  validates :name, presence: true
  validates :description, presence: true
  validates :organisation_id, presence: true
end
