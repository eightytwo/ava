class ApplicationController < ActionController::Base
  protect_from_forgery

  # Ensures only site administrators or organisation administrators
  # can send invitations.
  #
  protected
  def authenticate_inviter!
    if !user_signed_in? or
       (!current_user.admin? and !current_user.organisation_admin?)
      redirect_to root_url
    end
  end
end
