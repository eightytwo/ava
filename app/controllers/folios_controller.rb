class FoliosController < ApplicationController
  helper_method :folio, :organisation

  authority_action({
    new: 'manage',
    edit: 'manage',
    create: 'manage',
    update: 'manage',
    destroy: 'manage'
  })

  # GET /folios/1
  def show
    authorize_action_for(folio)

    @admins, @contributors, @viewers = [], [], []

    # Get the members of this folio and some of their user details
    # in one hit.
    folio_users = FolioUser
      .includes(:user)
      .joins(:user)
      .where(folio_id: folio)
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
    @rounds = folio.rounds.order("start_date DESC").all
  end

  # GET /folios/new?oid=1
  def new
    @folio = organisation.folios.build
    authorize_action_for(organisation)
  end

  # GET /folios/1/edit
  def edit
    authorize_action_for(organisation)
  end

  # POST /folios
  def create
    @folio = Folio.new(params[:folio])
    authorize_action_for(organisation)

    if @folio.save
      redirect_to @folio, notice: I18n.t("folio.create.success")
    else
      render action: :new
    end
  end

  # PUT /folios/1
  def update
    authorize_action_for(organisation)

    if folio.update_attributes(params[:folio])
      redirect_to folio.organisation, notice: I18n.t("folio.update.success")
    else
      render action: :edit
    end
  end

  # DELETE /folios/1
  def destroy
    authorize_action_for(organisation)

    folio.destroy
    redirect_to folio.organisation, notice: I18n.t("folio.delete.success")
  end

  private
  # Get the folio being operated on.
  #
  def folio
    @folio ||= Folio.find(params[:id])
  end

  # Gets the organisation of the folio.
  #
  # This is primarily required for the new action when no folio exists.
  #
  def organisation
    @organisation ||=
      params[:oid] ? Organisation.find(params[:oid]) : folio.organisation
  end
end
