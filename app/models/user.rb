class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable
         #, :registerable -- disabled while in organisation only mode

  # Setup accessible (or protected) attributes for the model.
  attr_accessible :username, :email, :password, :password_confirmation,
                  :remember_me

  # Virtual attribute for authenticating by either username or email.
  attr_accessor :login

  # Ensure a user's username is present, unique and of a suitable length.
  validates :username, :uniqueness => true, :length => { :within => 3..20 }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
