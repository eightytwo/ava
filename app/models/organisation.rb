class Organisation < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'OrganisationAdminAuthorizer'
  
  has_many :organisation_users, dependent: :delete_all
  has_many :users, through: :organisation_users
  has_many :folios, dependent: :delete_all
  has_many :audio_visual_categories, dependent: :destroy
  has_many :critique_categories, dependent: :destroy

  attr_accessible :name, :description, :website

  validates :name, presence: true
  validates :description, presence: true
end
