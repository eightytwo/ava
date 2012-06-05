class FolioUser < ActiveRecord::Base
  belongs_to :folio
  belongs_to :user
  belongs_to :folio_role
  
  attr_accessible :folio_id, :user_id, :folio_role_id

  validates :folio, presence: true
  validates :user, presence: true
  validates :folio_role, presence: true
end
