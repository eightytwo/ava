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
    has_first_name = (self.first_name and !self.first_name.blank?)
    has_last_name = (self.last_name and !self.last_name.blank?)

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
    organisation_display_name
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
    self.organisations.where(admin: true).order(:name)
  end

  # Returns true if the user is an administrator of a given organisation.
  #
  def administrator_of_organisation?(organisation)
    self.organisations
      .where("organisation_users.organisation_id = ? and admin = true",
             organisation)
      .count == 1
  end

  # Returns true if the user is a member of a given organisation.
  #
  def member_of_organisation?(organisation)
    self.organisations.where(id: organisation).count == 1
  end

  # Returns true if the user is an administrator of a given folio.
  #
  def administrator_of_folio?(folio)
    self.folios
      .where("folio_users.folio_id = ? and folio_role_id = 3", folio)
      .count == 1
  end

  # Returns true if the user is a contributor of a given folio.
  #
  def contributor_of_folio?(folio)
    self.folios
      .where("folio_users.folio_id = ? and folio_role_id >= 2", folio)
      .count == 1
  end

  # Returns true if the user is a member of a given folio.
  #
  def member_of_folio?(folio)
    self.folios.where(id: folio).count == 1
  end

  # Returns true if the user has critiqued a given round audio visual.
  #
  def has_critiqued_audio_visual(round_audio_visual)
    self.critiques.where(round_audio_visual_id: round_audio_visual).count > 0
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
    if organisation
      OrganisationUser.create(organisation_id: organisation.id,
                              user_id: self.id,
                              admin: self.invitation_organisation_admin)
    end

    if folio and folio_role
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
    if (self.last_name and !self.last_name.blank?) and
       (self.first_name.nil? or self.first_name.blank?)
      errors.add(:first_name, I18n.t("edit_account.errors.first_name"))
      return false
    end
  end
end
