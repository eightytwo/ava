class FolioUsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_folio_admin, except: [:new, :create]
  before_filter :ensure_organisation_admin, only: [:new, :create]

  # GET /folio_users/new
  def new
    @folio_user = FolioUser.new
    @folio_user.folio = @folio

    # Get members of the folio's organisation which do not belong to the folio.
    @members = User
      .joins(:organisation_users)
      .joins("LEFT JOIN folio_users ON folio_users.user_id = users.id")
      .where("organisation_users.organisation_id = ? AND (folio_users.folio_id IS NULL OR folio_users.folio_id <> ?)", @folio.organisation_id, @folio.id)
      .order("LOWER(COALESCE(users.first_name||users.last_name, users.first_name, users.username))")

    # Get the folio roles
    @folio_roles = FolioRole.select("id, name")
  end

  # GET /folio_users/1/edit
  def edit
    # Get the folio roles
    @folio_roles = FolioRole.select("id, name")
  end

  # POST /folio_users
  def create
    @folio_user = FolioUser.new(params[:folio_user])

    if @folio_user.save
      redirect_to @folio, notice: I18n.t("folio_user.create.success")
    else
      render action: "new"
    end
  end

  # PUT /folio_users/1
  def update
    if @folio_user.update_attributes(params[:folio_user])
      redirect_to @folio, notice: I18n.t("folio_user.update.success")
    else
      render action: "edit"
    end
  end

  # DELETE /folio_users/1
  def destroy
    @folio_user.destroy
    redirect_to @folio, notice: I18n.t("folio_user.delete.success")
  end

  protected
  # Ensures the current user is an administrator of the folio linked to 
  # the folio user or an administrator of the organisation to which the
  # folio of the folio user belongs.
  #
  def ensure_folio_admin
    folio_admin = false

    @folio_user = FolioUser
      .includes(:folio)
      .joins(:folio)
      .where(id: params[:id]).first

    if !@folio_user.nil?
      @folio = @folio_user.folio

      membership_summary = current_user.organisation_membership_summary(
        @folio.organisation, @folio)

      if !membership_summary.nil?
        folio_admin = (membership_summary[:organisation_admin] or
                      (membership_summary[:folio_role] == 3))
      end
    end

    redirect_to root_url if !folio_admin
  end

  # Ensures the current user is an administrator of the organisation to which
  # the folio of the folio user belongs.
  #
  def ensure_organisation_admin
    # This before filter is only run if a folio user is being created, in which
    # case no folio id will exist. A folio id will be passed in the querystring
    # to enable organisation administrator verification.
    folio_id = params.has_key?('fid') ? params[:fid] : params[:folio_user][:folio_id]
    @folio = Folio.find_by_id(folio_id)

    if !@folio.nil?
      organisation_user = OrganisationUser.find_by_organisation_and_user(
        @folio.organisation, current_user)

      if organisation_user.nil? or !organisation_user.admin
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end
end
