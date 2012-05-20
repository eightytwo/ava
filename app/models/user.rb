class User < ActiveRecord::Base
  has_many :organisation_users
  has_many :organisations, :through => :organisation_users
  has_many :folio_users
  has_many :folios, :through => :folio_users

  # Setup accessible (or protected) attributes for the model.
  attr_accessible :username, :email, :password, :password_confirmation,
                  :remember_me, :invitation_organisation_id,
                  :invitation_organisation_admin, :invitation_folio_id,
                  :invitation_folio_role_id

  # Virtual attribute for authenticating by either username or email.
  attr_accessor :login

  # Ensure a user's username is present, unique and of a suitable length.
  validates :username, :uniqueness => true, :length => { :within => 3..20 }

  # Include default devise modules. Others available are:
  # :token_authenticatable, # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable
         #, :registerable -- disabled while in organisation only mode 

  # Devise invitable callback for when a user accepts an invitation.
  after_invitation_accepted :email_invited_by

  # Allows a user to be authenticated by either email address or username.
  #
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # Executed after a user accepts an invitation.
  #
  def email_invited_by
    # Retrieve the organisation related properties of the invitation.
    organisation = Organisation.find(self.invitation_organisation_id)
    folio = Folio.find(self.invitation_folio_id)
    folio_role = FolioRole.find(self.invitation_folio_role_id)

    # Establish the user in the organisation and folio.
    if !organisation.nil?
      OrganisationUser.create(organisation: organisation,
                              user: self,
                              admin: self.invitation_organisation_admin)
    end

    if !folio.nil? and !folio_role.nil?
      FolioUser.create(folio: folio,
                       user: self,
                       folio_role: folio_role)
    end
  end

  # Returns true if the user is an administrator of an organisation,
  # otherwise false.
  #
  def organisation_admin?
    self.organisation_users.where(admin: true).count > 0
  end

  # Returns true if the user belongs to an organisation, otherwise false.
  #
  def organisations?
    self.organisations.count > 0
  end
end
