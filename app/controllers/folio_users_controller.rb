class FolioUsersController < ApplicationController
  helper_method :folio_user, :folio, :organisation

  authority_action({
    new: 'manage',
    edit: 'manage',
    create: 'manage',
    update: 'manage',
    destroy: 'manage'
  })

  # GET /folio_users/new
  def new
    authorize_action_for(organisation)

    @folio_user = folio.folio_users.build

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
    authorize_action_for(folio)

    # Get the folio roles
    @folio_roles = FolioRole.select("id, name")
  end

  # POST /folio_users
  def create
    @folio_user = FolioUser.new(params[:folio_user])
    authorize_action_for(organisation)

    if @folio_user.save
      redirect_to folio, notice: I18n.t("folio_user.create.success")
    else
      render action: :new
    end
  end

  # PUT /folio_users/1
  def update
    authorize_action_for(folio)

    if folio_user.update_attributes(params[:folio_user])
      redirect_to folio, notice: I18n.t("folio_user.update.success")
    else
      render action: :edit
    end
  end

  # DELETE /folio_users/1
  def destroy
    authorize_action_for(folio)

    folio_user.destroy
    redirect_to folio, notice: I18n.t("folio_user.delete.success")
  end

  private
  # Gets the folio user being operated on.
  #
  def folio_user
    @folio_user ||= FolioUser.find(params[:id])
  end

  # Gets the folio of the folio user.
  #
  # This is primarily required for the new action when no folio exists.
  #
  def folio
    @folio ||= params[:fid] ? Folio.find(params[:fid]) : folio_user.folio
  end

  # Gets the organisation of the folio.
  #
  def organisation
    @organisation ||= folio.organisation
  end
end
