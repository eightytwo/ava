class InvitationsController < Devise::InvitationsController
  before_filter :get_organisation_data, only: [:new, :create]

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
       self.resource.errors.add(:folio, "must be supplied")
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

  protected
  # Retrieve data for organisation related drop down lists
  # if the inviter belongs to an organisation.
  #
  def get_organisation_data
    if current_user.organisations?
      @organisations = current_user.administered_organisations
      @folios = @organisations[0].folios
      @folio_roles = FolioRole.all
    end
  end
end
