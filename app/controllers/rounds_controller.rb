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
      redirect_to @folio, notice: I18n.t("round.updated.success")
    else
      render action: "edit"
    end
  end

  # DELETE /rounds/1
  def destroy
    @round.destroy
    redirect_to @folio
  end

  protected
  # Ensures the current user is a member of the requested folio.
  #
  def ensure_folio_member
    @round = Round.find_by_id(params[:id])

    if @round.nil? or !current_user.member_of_folio?(@round.folio)
      redirect_to root_url
    else
      @folio_admin = current_user.admin_of_folio?(@round.folio)
    end
  end

  # Ensures the current user is an administrator of the requested folio.
  #
  def ensure_folio_admin
    @round = Round.find_by_id(params[:id])

    # No round will exist if the user is creating a new one in which case
    # the folio id will be supplied in the querystring.
    if @round.nil?
      folio_id = params.has_key?('fid') ? params[:fid] : params[:round][:folio_id]
      @folio = Folio.find_by_id(folio_id)
    else
      @folio = @round.folio
    end

    if @folio.nil? or !current_user.admin_of_folio?(@folio)
      redirect_to root_url
    end
  end
end
