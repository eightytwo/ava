class FolioUser < ActiveRecord::Base
  belongs_to :folio
  belongs_to :user
  belongs_to :folio_role
  
  attr_accessible :folio, :user, :folio_role
  accepts_nested_attributes_for :folio, :user, :folio_role
end
