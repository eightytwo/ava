class OrganisationUser < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :user
  
  attr_accessible :organisation_id, :user, :admin

  validates :organisation, presence: true
  validates :user, presence: true
  validate :last_administrator, if: "!admin"

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
  # Ensures an organisation cannot be left with no administrators.
  # TODO: This may be better implemented as a trigger.
  #
  def last_administrator
    # Check if this user is currently stored as an organisation administrator.
    is_admin = OrganisationUser.find(self.id).admin
    num_admins = OrganisationUser.where("organisation_id = ? and admin = true",
      self.organisation.id).count

    if is_admin and num_admins == 1
      errors[:base] << I18n.t("organisation_user.update.errors.no_admin")
    end
  end
end
