class OrganisationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_organisation_member
  before_filter :ensure_organisation_admin, :except => :show

  # GET /organisations/1
  def show
  end

  # GET /organisations/1/edit
  def edit
  end

  # PUT /organisations/1
  def update
    if @organisation.update_attributes(params[:organisation])
      redirect_to @organisation, notice: 'Organisation was successfully updated.'
    else
      render action: "edit"
    end
  end

  protected
  # Ensures the current user is a member of the requested organisation.
  #
  def ensure_organisation_member
    @organisation = Organisation.find_by_id(params[:id])

    if @organisation.nil? or !current_user.member_of_organisation?(@organisation)
      redirect_to root_url
    else
      @organisation_admin = current_user.admin_of_organisation?(@organisation)
    end
  end

  # Ensures the current user is an administrator of the requested organisation.
  #
  def ensure_organisation_admin
    redirect_to root_url unless @organisation_admin
  end
end
