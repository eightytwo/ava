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
      # Get the first user record which corresponds to the given email.
      user = User.where(email: params[:user][:email]).first

      # If the user already exists and this invitation is for an organisation
      # we don't need to involve devise and can simply add the existing user
      # to the nominated organisation and folio. Otherwise invoke the devise
      # invitations controller.
      if user and params[:user].has_key?(:invitation_folio_id)
        # Check if the user already belongs to the nominated organisaton.
        organisation_user = OrganisationUser.where(
          "organisation_id = ? and user_id = ?",
          params[:user][:invitation_organisation_id],
          user.id).first

        if organisation_user
          self.resource = build_resource
          self.resource.errors[:base] << I18n.t(
            "invitation.create.errors.organisation_user_exists")
          respond_with_navigational(resource) { render :new }
        else
          # Add the user to the organisation and folio.
          ou = OrganisationUser.create(
            organisation_id: params[:user][:invitation_organisation_id],
            user_id: user.id)

          FolioUser.new(
            folio_id: params[:user][:invitation_folio_id],
            user_id: user.id,
            folio_role_id: params[:user][:invitation_folio_role_id]).save

          # Send out a communication.
          OrganisationUserMailer.new_organisation_user(ou).deliver

          redirect_to organisations_path(ou.organisation_id)
        end
      else
        super
      end
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
