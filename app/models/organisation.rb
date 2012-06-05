class Organisation < ActiveRecord::Base
  has_many :organisation_users
  has_many :users, through: :organisation_users
  has_many :folios
  has_many :audio_visual_categories
  has_many :critique_categories

  attr_accessible :name, :description, :website

  validates :name, presence: true
  validates :description, presence: true
end
