class OrganisationUser < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :user
  
  attr_accessible :organisation_id, :user_id, :admin

  validates :organisation_id, presence: true
  validates :user_id, presence: true
  validate :last_administrator, if: "!admin"

  before_destroy :last_administrator

  # Retrieves an OrganisationUser record for a given organisation and user.
  #
  def self.find_by_organisation_and_user(organisation, user)
    organisation_user = nil

    # Ensure the organisation and user objects are qualified.
    if !organisation.nil? and !user.nil?
      organisation_user = OrganisationUser.where("organisation_id = ? and user_id = ?",
        organisation.id, user.id).first
    end

    return organisation_user
  end

  private
  # Ensures an organisation cannot be left with no administrators, either
  # through the deletion of the last administrator or updating the admin
  # property of the last administrator to false.
  #
  def last_administrator
    if !self.organisation_id.nil?
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
end
