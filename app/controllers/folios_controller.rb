class FoliosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_folio_member, only: :show
  before_filter :ensure_organisation_admin, except: :show

  # GET /folios/1
  def show
    @admins = @folio.users.where("folio_role_id = 3").order(:username)
    @contributors = @folio.users.where("folio_role_id = 2").order(:username)
    @viewers = @folio.users.where("folio_role_id = 1").order(:username)
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
      redirect_to @folio, notice: 'Folio was successfully created.'
    else
      render action: "new"
    end    
  end

  # PUT /folios/1
  def update
    if @folio.update_attributes(params[:folio])
      redirect_to @organisation, notice: 'Folio was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /folios/1
  def destroy
    @folio.destroy
    redirect_to @organisation
  end

  protected
  # Ensures the current user is a member of the requested folio.
  #
  def ensure_folio_member
    @folio = Folio.find_by_id(params[:id])

    if @folio.nil? or !current_user.member_of_folio?(@folio)
      redirect_to root_url
    else
      @folio_admin = current_user.admin_of_folio?(@folio)
    end
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

    if @organisation.nil? or !current_user.admin_of_organisation?(@organisation)
      redirect_to root_url
    end
  end
end
