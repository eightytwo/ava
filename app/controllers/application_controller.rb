class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  # Ensures only site administrators or organisation administrators
  # can send invitations.
  #
  def authenticate_inviter!
    if !user_signed_in? or
       (!current_user.admin? and !current_user.organisation_admin?)
      redirect_to root_url
    end
  end

  # Redirects the user after login to one of the following:
  #   - the page they were intending on visiting
  #     (prior to being redirected to sign in)
  #   - the organisation home page if they belong to an organisation
  #   - the root path of the website.
  #
  def after_sign_in_path_for(resource)
    if !session["user_return_to"].nil?
      session["user_return_to"]
    elsif current_user.organisations.count > 0
      organisations_path
    else
      super
    end
  end
end
