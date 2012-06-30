class OrganisationsController < ApplicationController
  helper_method :organisation

  authority_action({ edit: 'manage', update: 'manage' })

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
    authorize_action_for(organisation)

    @admins, @members = [], []

    # Get the members of this Organisation and some of their user details
    # in one hit.
    organisation_users = OrganisationUser
      .includes(:user)
      .joins(:user)
      .where(organisation_id: organisation.id)      
      .order("LOWER(COALESCE(users.first_name||users.last_name, users.first_name, users.username))")

    # Separate the administrators and members into their own arrays.
    organisation_users.each do |u|
      u.admin ? @admins.append(u) : @members.append(u)
    end

    # Get the folios of the Organisation.
    @folios = organisation.folios.order(:name).all
  end

  # GET /organisations/1/edit
  def edit
    authorize_action_for(organisation)
  end

  # PUT /organisations/1
  def update
    authorize_action_for(organisation)

    if organisation.update_attributes(params[:organisation])
      redirect_to organisation, notice: I18n.t("organisation.update.success")
    else
      render action: "edit"
    end
  end

  private
  # Gets the organisation being operated on.
  #
  def organisation
    @organisation ||= Organisation.find(params[:id])
  end
end
