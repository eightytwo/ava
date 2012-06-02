class OrganisationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_organisation_member, except: :index
  before_filter :ensure_organisation_admin, except: [:index, :show]

  # GET /organisations
  def index
    @organisations = current_user.organisations

    if (@organisations.nil? or (@organisations.count == 0))
      redirect_to root_url
    elsif @organisations.count == 1
      redirect_to @organisations[0]
    end
  end

  # GET /organisations/1
  def show
    @admins, @members = [], []

    # Get the members of this organisation and some of their user details
    # in one hit.
    organisation_users = OrganisationUser
      .includes(:user)
      .joins(:user)
      .where(organisation_id: @organisation)      
      .order("LOWER(COALESCE(users.first_name||users.last_name, users.first_name, users.username))")

    # Separate the administrators and members into their own arrays.
    organisation_users.each do |u|
      u.admin ? @admins.append(u) : @members.append(u)
    end

    # Get the folios of the organisation.
    @folios = Folio.where(organisation_id: @organisation).order(:name).all
  end

  # GET /organisations/1/edit
  def edit
  end

  # PUT /organisations/1
  def update
    if @organisation.update_attributes(params[:organisation])
      redirect_to @organisation, notice: I18n.t("organisation.update.success")
    else
      render action: "edit"
    end
  end

  protected
  # Ensures the current user is a member of the requested organisation.
  #
  def ensure_organisation_member
    @organisation = Organisation.find_by_id(params[:id])

    if @organisation.nil?
      redirect_to root_url
    else
      # Get the current user's membership in this organisation.
      organisation_user = OrganisationUser.find_by_organisation_and_user(
        @organisation, current_user)

      if organisation_user.nil?
        redirect_to root_url
      else
        @organisation_admin = organisation_user.admin
      end
    end
  end

  # Ensures the current user is an administrator of the requested organisation.
  #
  def ensure_organisation_admin
    redirect_to root_url unless @organisation_admin
  end
end
