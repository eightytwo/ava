class Folio < ActiveRecord::Base
  belongs_to :organisation
  has_many :folio_users, dependent: :delete_all
  has_many :users, through: :folio_users
  has_many :rounds, dependent: :delete_all

  attr_accessible :description, :name, :organisation_id

  validates :name, presence: true
  validates :description, presence: true
  validates :organisation, presence: true
end
