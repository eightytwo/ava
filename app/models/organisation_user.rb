class OrganisationUser < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :user
  
  attr_accessible :organisation_id, :user_id, :admin

  validates :organisation_id, presence: true
  validates :user_id, presence: true
  validate :last_administrator, if: "!admin"

  before_destroy :last_administrator
  after_destroy :remove_folio_user

  private
  # Ensures an organisation cannot be left with no administrators, either
  # through the deletion of the last administrator or updating the admin
  # property of the last administrator to false.
  #
  def last_administrator
    if self.organisation_id
      # Check if this user is currently stored as an organisation administrator
      # and get the number of administrators in the organisation.
      is_admin = (self.admin or (!self.admin and self.admin_changed?))
      num_admins = OrganisationUser.where("organisation_id = ? and admin = true",
        self.organisation_id).count

      if is_admin and num_admins == 1
        errors[:base] << I18n.t("organisation_user.update.errors.no_admin")
        return false
      end
    end
  end

  # Removes the user from any folios within the organisation they are being
  # removed from.
  #
  def remove_folio_user
    FolioUser.delete_all(
      ["folio_id IN (?) and user_id = ?",
       self.organisation.folios.map(&:id), self.user_id])
  end
end
