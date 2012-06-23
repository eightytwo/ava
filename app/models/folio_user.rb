class FolioUser < ActiveRecord::Base
  belongs_to :folio
  belongs_to :user
  belongs_to :folio_role
  
  attr_accessible :folio_id, :user_id, :folio_role_id

  validates :folio_id, presence: true
  validates :user_id, presence: true
  validates :folio_role_id, presence: true
end
