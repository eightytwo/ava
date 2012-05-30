class RoundsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_folio_member, only: :show
  before_filter :ensure_folio_admin, except: :show

  # GET /rounds/1
  def show
  end

  # GET /rounds/new
  def new
    @round = Round.new
  end

  # GET /rounds/1/edit
  def edit
  end

  # POST /rounds
  def create
    @round = Round.new(params[:round])

    if @round.save
      redirect_to @round, notice: I18n.t("round.create.success")
    else
      render action: "new"
    end
  end

  # PUT /rounds/1
  def update
    if @round.update_attributes(params[:round])
      redirect_to @folio, notice: I18n.t("round.update.success")
    else
      render action: "edit"
    end
  end

  # DELETE /rounds/1
  def destroy
    @round.destroy
    redirect_to @folio, notice: I18n.t("round.delete.success")
  end

  protected
  # Ensures the current user is a member of the requested folio.
  #
  def ensure_folio_member
    is_member = false
    @round = Round
      .includes(:folio)
      .joins(:folio)
      .where(id: params[:id]).first
      # .joins(:organisation)
      # .includes(:organisation)

    if !@round.nil?
      membership_summary = current_user.organisation_membership_summary(
        @round.folio.organisation, @round.folio)

      if !membership_summary.nil?
        organisation_admin = membership_summary[:organisation_admin]
        folio_role = membership_summary[:folio_role]

        is_member = organisation_admin or !folio_role.nil?
        @folio_admin = (organisation_admin or (folio_role == 3))
      end
    end

    redirect_to root_url if !is_member
  end

  # Ensures the current user is an administrator of the requested folio.
  #
  def ensure_folio_admin
    folio_admin = false
    @round = Round.find_by_id(params[:id])

    # No round will exist if the user is creating a new one in which case
    # the folio id will be supplied in the querystring.
    if @round.nil?
      folio_id = params.has_key?('fid') ? params[:fid] : params[:round][:folio_id]
      @folio = Folio.find_by_id(folio_id)
    else
      @folio = @round.folio
    end

    if !@folio.nil?
      membership_summary = current_user.organisation_membership_summary(
          @folio.organisation, @folio)

      if !membership_summary.nil? and
        (membership_summary[:organisation_admin] or
         membership_summary[:folio_role] == 3)
        folio_admin = true
      end
    end

    redirect_to root_url if !folio_admin
  end
end
