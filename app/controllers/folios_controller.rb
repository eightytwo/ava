class FoliosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_folio_member, only: :show
  before_filter :ensure_organisation_admin, except: :show

  # GET /folios/1
  def show
    @admins, @contributors, @viewers = [], [], []

    # Get the members of this folio and some of their user details
    # in one hit.
    folio_users = FolioUser
      .includes(:user)
      .joins(:user)
      .where(folio_id: @folio)
      .order("LOWER(COALESCE(users.first_name||users.last_name, users.first_name, users.username))")

    # Separate the administrators and members into their own arrays.
    folio_users.each do |u|
      case u.folio_role_id
        when 1
          @viewers.append(u)
        when 2
          @contributors.append(u)
        when 3
          @admins.append(u)
      end
    end

    # Get the folios of the organisation.
    @rounds = Round.where(folio_id: @folio).all
  end

  # GET /folios/new?oid=1
  def new
    @folio = Folio.new
  end

  # GET /folios/1/edit
  def edit
  end

  # POST /folios
  def create
    @folio = Folio.new(params[:folio])

    if @folio.save
      redirect_to @folio, notice: I18n.t("folio.create.success")
    else
      render action: "new"
    end
  end

  # PUT /folios/1
  def update
    if @folio.update_attributes(params[:folio])
      redirect_to @organisation, notice: I18n.t("folio.update.success")
    else
      render action: "edit"
    end
  end

  # DELETE /folios/1
  def destroy
    @folio.destroy
    redirect_to @organisation, notice: I18n.t("folio.delete.success")
  end

  protected
  # Ensures the current user is a member of the requested folio.
  #
  def ensure_folio_member
    is_member = false

    # Get the folio in question and ensure it exists.
    @folio = Folio
      .includes(:organisation)
      .joins(:organisation)
      .where(id: params[:id]).first

    if !@folio.nil?
      membership_summary = current_user.organisation_membership_summary(
        @folio.organisation, @folio)

      if !membership_summary.nil?
        @folio_admin = membership_summary[:organisation_admin] or
                       membership_summary[:folio_role_id] == 3

        is_member = !membership_summary[:folio_role].nil?
      end
    end

    redirect_to root_url if !is_member and !@folio_admin
  end

  # Ensures the current user is an administrator of the requested organisation.
  # This check is required when creating a new folio as no folio administrators
  # will exist at that point in time.
  #
  def ensure_organisation_admin
    @folio = Folio.find_by_id(params[:id])

    # No folio will exist if the user is creating a new one in which case
    # the organisation id will be supplied in the querystring.
    if @folio.nil?
      organisation_id = params.has_key?('oid') ? params[:oid] : params[:folio][:organisation_id]
      @organisation = Organisation.find_by_id(organisation_id)
    else
      @organisation = @folio.organisation
    end

    # Get the organisation user record for the organisation and current user.
    organisation_user = OrganisationUser.find_by_organisation_and_user(
      @organisation, current_user)

    # Redirect if the current user is not an organisation admin.
    if organisation_user.nil? or !organisation_user.admin
      redirect_to root_url
    end
  end
end
