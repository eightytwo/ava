class User < ActiveRecord::Base
  include Authority::UserAbilities

  has_many :organisation_users, dependent: :delete_all
  has_many :organisations, through: :organisation_users
  has_many :folio_users, dependent: :delete_all
  has_many :folios, through: :folio_users
  has_many :critiques, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :audio_visuals, dependent: :delete_all

  # Ensure null is inserted into these columns if empty string.
  nilify_blanks :only => [:first_name, :last_name]

  # Setup accessible (or protected) attributes for the model.
  attr_accessible :username, :email, :password, :password_confirmation,
                  :first_name, :last_name, :remember_me,
                  :invitation_organisation_id, :invitation_organisation_admin,
                  :invitation_folio_id, :invitation_folio_role_id

  # Virtual attribute for authenticating by either username or email.
  attr_accessor :login

  # Ensure a user's username is present, unique and of a suitable length.
  validates :username, presence: true, uniqueness: true, length: { :within => 3..20 }
  validate :last_name_if_first_name_exists

  # Include default devise modules. Others available are:
  # :token_authenticatable, # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
         :registerable

  # Devise invitable callback for when a user accepts an invitation.
  after_invitation_accepted :invitation_accepted

  # Allows a user to be authenticated by either email address or username.
  #
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where([
        "lower(username) = :value OR lower(email) = :value",
        { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # The name of the user for their greeting which will be either their
  # first name if set otherwise their username.
  #
  def greeting_name
    if self.first_name.nil? or self.first_name.blank?
      self.username
    else
      self.first_name
    end
  end

  # The name to use when displaying this user in the context of an
  # organisation. Try their full name, otherwise just the
  # first, and failing that use their username.
  #
  def organisation_display_name
    has_first_name = !(self.first_name.nil? or self.first_name.blank?)
    has_last_name = !(self.last_name.nil? or self.last_name.blank?)

    if has_first_name and has_last_name
      [self.first_name, self.last_name].join(" ")
    elsif has_first_name
      self.first_name
    else
      self.username
    end
  end

  # The name to use when displaying this user publicly.
  #
  def public_display_name
    return organisation_display_name
  end

  # Returns true if the user belongs to an organisation, otherwise false.
  #
  def organisations?
    self.organisations.count > 0
  end

  # Returns true if the user is an administrator of an organisation,
  # otherwise false.
  #
  def organisation_admin?
    self.organisation_users.where(admin: true).count > 0
  end

  # Returns the organisations of which the user is an administrator.
  #
  def administered_organisations
    return self.organisations.where("admin = true")
  end

  # Returns a summary of the user's membership of a given organisation
  # and folio.
  #
  def organisation_membership_summary(organisation, folio)
    # Setup a default result package.
    result = {
      organisation_member: false,
      organisation_admin: false,
      folio_member: false,
      folio_role: 0
    }

    # Get the id of the folio if supplied, otherwise set to zero.
    folio_id = folio.nil? ? 0 : folio.id

    if !organisation.nil?
      summary = User
        .select("organisation_users.admin AS organisation_admin, folio_users.folio_role_id AS folio_role")
        .joins("INNER JOIN organisation_users ON organisation_users.user_id = users.id AND organisation_users.organisation_id = " + organisation.id.to_s)
        .joins("LEFT JOIN folio_users ON folio_users.user_id = users.id AND folio_users.folio_id = " + folio_id.to_s)
        .where(id: self.id ).first

      if !summary.nil?
        result[:organisation_member] = true
        result[:organisation_admin] = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(summary.organisation_admin)
        
        if !summary.folio_role.nil?
          result[:folio_member] = true
          result[:folio_role] = summary.folio_role.to_i
        end
      end
    end

    return result
  end

  private
  # A callback which is executed after a user accepts an invitation.
  #
  def invitation_accepted
    # Retrieve the organisation related properties of the invitation.
    organisation = Organisation.find(self.invitation_organisation_id)
    folio = Folio.find(self.invitation_folio_id)
    folio_role = FolioRole.find(self.invitation_folio_role_id)

    # Establish the user in the organisation and folio.
    if !organisation.nil?
      OrganisationUser.create(organisation_id: organisation.id,
                              user_id: self.id,
                              admin: self.invitation_organisation_admin)
    end

    if !folio.nil? and !folio_role.nil?
      FolioUser.create(folio_id: folio.id,
                       user_id: self.id,
                       folio_role_id: folio_role.id)
    end

    # Set the relevant invitation columns to null such that foreign key
    # errors are not encountered, such as a folio being deleted in the
    # future.
    self.invitation_organisation_id = nil
    self.invitation_organisation_admin = nil
    self.invitation_folio_id = nil
    self.invitation_folio_role_id = nil
    self.save!
  end

  # Ensures the user has a first name if a last name has been supplied.
  #
  def last_name_if_first_name_exists
    if !(self.last_name.nil? or self.last_name.blank?) and
       (self.first_name.nil? or self.first_name.blank?)
      errors.add(:first_name, I18n.t("edit_account.errors.first_name"))
      return false
    end
  end
end
