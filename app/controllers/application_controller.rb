class ApplicationController < ActionController::Base
  protect_from_forgery

  # Ensures only site administrators or organisation administrators
  # can send invitations.
  #
  protected
  def authenticate_inviter!
    redirect_to root_url unless user_signed_in? and
      (current_user.admin? or current_user.organisation_admin?)
  end
end
