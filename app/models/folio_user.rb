class FolioUser < ActiveRecord::Base
  belongs_to :folio
  belongs_to :user
  belongs_to :folio_role
  
  attr_accessible :folio_id, :user_id, :folio_role_id

  validates :folio, presence: true
  validates :user, presence: true
  validates :folio_role, presence: true

  # Retrieves a FolioUser record for a given folio and user.
  #
  def self.find_by_folio_and_user(folio, user)
    folio_user = nil

    # Ensure the folio and user objects are qualified.
    if !folio.nil? and !user.nil?
      folio_user = FolioUser.where("folio_id = ? and user_id = ?",
        folio.id, user.id).first
    end

    return folio_user
  end
end
