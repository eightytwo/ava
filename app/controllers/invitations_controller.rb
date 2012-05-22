class InvitationsController < Devise::InvitationsController
  before_filter :get_organisation_data, :only => [:new, :create]

  # GET /resource/invitation/new
  def new
    super
  end

  # POST /resource/invitation
  def create    
    super
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
