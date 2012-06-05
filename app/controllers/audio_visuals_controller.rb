class AudioVisualsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_folio_member, only: :show
  before_filter :ensure_av_owner, only: [:edit, :update, :destroy]
  before_filter :ensure_folio_contributor, only: [:new, :create]

  # GET /audio_visuals/1
  def show
  end

  # GET /audio_visuals/new
  def new
    @audio_visual = AudioVisual.new
  end

  # GET /audio_visuals/1/edit
  def edit
  end

  # POST /audio_visuals
  def create
    if @round.nil? or (!@round.nil? and @round.open?)
      @audio_visual = AudioVisual.new(params[:audio_visual])
      @audio_visual.user_id = current_user.id

      if @audio_visual.save
        redirect_to @audio_visual, notice: I18n.t("audio_visual.create.success")
      else
        render action: "new"
      end
    end
  end

  # PUT /audio_visuals/1
  def update
    if @audio_visual.update_attributes(params[:audio_visual])
      redirect_to @audio_visual, notice: I18n.t("audio_visual.update.success")
    else
      render action: "edit"
    end
  end

  # DELETE /audio_visuals/1
  def destroy
    @audio_visual.destroy

    if !@round.nil?
      redirect_to rounds_url(@round), notice: I18n.t("audio_visual.delete.success")
    else
      redirect_to root_url, notice: I18n.t("audio_visual.delete.success")
    end
  end

  private
  # Ensures the current user is a member of the folio to which this audio
  # visual belongs or is an administrator of the organisation to which this
  # audio visual ultimately belongs.
  #
  def ensure_folio_member
    redirect = true
    @owner = false
    @folio_member = false
    @folio_role = 0

    @audio_visual = AudioVisual
      .includes(round: { folio: :organisation })
      .joins(round: { folio: :organisation })
      .where(id: params[:id]).first

    if !@audio_visual.nil?
      @owner = (@audio_visual.user_id == current_user.id)

      if !@audio_visual.round_id.nil?
        membership = current_user.organisation_membership_summary(
          @audio_visual.round.folio.organisation, @audio_visual.round.folio)

        if (!membership.nil? and
            (membership[:organisation_admin] or !membership[:folio_role].nil?))
          @folio_member = true
          @folio_role = (membership[:folio_role].nil? ? 3 : membership[:folio_role])
          redirect = false
        end
      end
    end

    redirect_to root_url if redirect
  end

  # Ensures the current user is a contributor of the folio of the supplied
  # round. At this stage if no round is supplied no contributions to the
  # site can be made.
  #
  def ensure_folio_contributor
    redirect = true
    round_id = params[:rid] ? params[:rid] : params[:audio_visual][:round_id]

    @round = Round
      .includes(folio: :organisation)
      .joins(folio: :organisation)
      .where(id: round_id).first

    if !@round.nil?
      membership = current_user.organisation_membership_summary(
        @round.folio.organisation, @round.folio)

      if !membership.nil? and
         ((membership[:organisation_admin] or
          (!membership[:folio_role].nil? and membership[:folio_role] >= 2)))
        redirect = false
        @audio_visual_categories = 
          @round.folio.organisation.audio_visual_categories.order(:name).all
      end
    end

    redirect_to root_url if redirect
  end

  # Ensures the current user is the owner of the audio visual.
  #
  def ensure_av_owner
    owner = false
    @audio_visual = AudioVisual
      .includes(round: { folio: :organisation })
      .joins(round: { folio: :organisation })
      .where(id: params[:id]).first

    if !@audio_visual.nil?
      @round = @audio_visual.round

      # If this audio visual belongs to a round get the audio visual
      # categories of the organisation.
      if !@round.nil?
        @audio_visual_categories = 
          @round.folio.organisation.audio_visual_categories.order(:name).all
      end

      if @audio_visual.user_id == current_user.id
        owner = true
      else
        if !@audio_visual.round_id.nil?
          membership = current_user.organisation_membership_summary(
            @audio_visual.round.folio.organisation, @audio_visual.round.folio)

          if !membership.nil? and
             (membership[:organisation_admin] or
              (!membership[:folio_role].nil? and membership[:folio_role] == 3))
            owner = true
          end
        end
      end
    end

    redirect_to root_url if !owner
  end
end
