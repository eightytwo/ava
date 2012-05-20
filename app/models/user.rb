class User < ActiveRecord::Base
  has_many :organisation_users
  has_many :organisations, :through => :organisation_users

  # Setup accessible (or protected) attributes for the model.
  attr_accessible :username, :email, :password, :password_confirmation,
                  :remember_me

  # Virtual attribute for authenticating by either username or email.
  attr_accessor :login

  # Include default devise modules. Others available are:
  # :token_authenticatable, # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable
         #, :registerable -- disabled while in organisation only mode 

  # Ensure a user's username is present, unique and of a suitable length.
  validates :username, :uniqueness => true, :length => { :within => 3..20 }

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

  # Returns true if the user is an administrator of an organisation,
  # otherwise false.
  #
  def organisation_admin?
    self.organisation_users.where(admin: true).count > 0
  end
end
