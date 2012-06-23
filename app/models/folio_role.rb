class FolioRole < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :folio_users, dependent: :restrict

  validates :name, presence: true
  validates :description, presence: true
end
