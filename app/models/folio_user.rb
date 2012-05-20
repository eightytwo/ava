class FolioUser < ActiveRecord::Base
  belongs_to :folio
  belongs_to :user
  belongs_to :folio_role
  
end
