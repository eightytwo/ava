class OrganisationUsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_organisation_admin

  # GET /organisation_users/1/edit
  def edit
  end

  # PUT /organisation_users/1
  def update   
    if @organisation_user.update_attributes(params[:organisation_user])
     redirect_to @organisation_user.organisation, notice: I18n.t("organisation_user.update.success")
    else
     render action: "edit"
    end
  end

  # DELETE /organisation_users/1
  def destroy
    # Get the organisation and user objects.
    organisation = @organisation_user.organisation
    user = @organisation_user.user

    # Delete the organisation_user relation record.
    if @organisation_user.destroy
      folios = organisation.folios
      FolioUser.delete_all(
        ["folio_id IN (?) and user_id = ?", folios.map {|f| f.id}, user.id])
    end
    
    # Go back to the organisation page.
    redirect_to organisation, notice: I18n.t("organisation_user.delete.success")
  end

  protected
  # Ensures the current user is an administrator of the organisation.
  #
  def ensure_organisation_admin
    @organisation_user = OrganisationUser
      .includes(:user, :organisation)
      .joins(:user)
      .joins(:organisation)
      .where("organisation_users.id = ?", params[:id]).first

    if @organisation_user.nil?
     redirect_to root_url
    else
      # Get the current user's membership in this organisation.
      current_organisation_user = OrganisationUser.find_by_organisation_and_user(
        @organisation_user.organisation, current_user)

      if current_organisation_user.nil? or !current_organisation_user.admin
       redirect_to root_url
      end
    end
  end
end
