class InvitationsController < Devise::InvitationsController
  # GET /resource/invitation/new
  def new
    # Retrieve data for organisation related drop down lists
    # if the inviter belongs to an organisation.
    if current_user.organisations?
      @organisations = current_user.organisations
      @folios = current_user.organisations[0].folios
      @folio_roles = FolioRole.all
    end

    super
  end

  # POST /resource/invitation
  def create
    # Retrieve data for organisation related drop down lists
    # if the inviter belongs to an organisation.
    if current_user.organisations?
      @organisations = current_user.organisations
      @folios = current_user.organisations[0].folios
      @folio_roles = FolioRole.all
    end
    
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
end
