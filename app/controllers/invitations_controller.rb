class InvitationsController < Devise::InvitationsController
  skip_before_filter :authenticate_user!
  
  helper_method :organisations, :folios, :folio_roles

  # GET /resource/invitation/new
  def new
    super
  end

  # POST /resource/invitation
  def create
    # If this is an invitation to an organisation, ensure a
    # folio has been supplied.
    if params[:user].has_key?(:invitation_organisation_id) and
       !params[:user].has_key?(:invitation_folio_id)

      # Construct the resource and add the error message.
      self.resource = build_resource
      self.resource.errors.add(
        :folio, I18n.t("invitation.create.errors.folio_required"))
      respond_with_navigational(resource) { render :new }
    else
      super
    end
  end

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    super
  end

  # PUT /resource/invitation
  def update
    super
  end

  private
  # Gets the organisations administered by the current user. The current
  # user can invite someone to join these organisations.
  #
  def organisations
    @organisations ||= current_user.administered_organisations
  end

  # Gets the folios of the first organisation administered by the current
  # user.
  #
  def folios
    @folios ||= organisations[0].folios
  end

  # Gets the folio roles.
  #
  def folio_roles
    @folio_roles ||= FolioRole.all
  end
end
