class OrganisationUsersController < ApplicationController
  helper_method :organisation_user

  authority_action({
    edit: 'manage',
    update: 'manage',
    destroy: 'manage'
  })

  # GET /organisation_users/1/edit
  def edit
    authorize_action_for(organisation_user.organisation)
  end

  # PUT /organisation_users/1
  def update
    authorize_action_for(organisation_user.organisation)

    if organisation_user.update_attributes(params[:organisation_user])
      redirect_to(
        organisation_user.organisation,
        notice: I18n.t("organisation_user.update.success"))
    else
      render action: "edit"
    end
  end

  # DELETE /organisation_users/1
  def destroy
    authorize_action_for(organisation_user.organisation)
    organisation = organisation_user.organisation

    # Delete the OrganisationUser relation record.
    if organisation_user.destroy
      redirect_to(
        organisation,
        notice: I18n.t("organisation_user.delete.success"))
    end
  end

  private
  # Get the OrganisationUser record being operated on.
  #
  def organisation_user
    @organisation_user ||= OrganisationUser
      .includes(:user, :organisation)
      .joins(:user)
      .joins(:organisation)
      .where("organisation_users.id = ?", params[:id]).first
  end
end
