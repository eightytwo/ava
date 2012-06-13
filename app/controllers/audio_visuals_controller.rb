class AudioVisualsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_folio_member, only: :show
  before_filter :ensure_av_owner, only: [:edit, :update, :destroy]
  before_filter :ensure_folio_contributor, only: [:new, :create, :critiques]

  # GET /av/1/critiques
  def critiques
    @critiques = Critique
      .includes(critique_components: :critique_category)
      .joins(critique_components: :critique_category)
      .where(audio_visual_id: params[:id])
      .order("critiques.updated_at DESC, critique_components.id ASC")

    render layout: false
  end

  # GET /av/1/comments
  def comments
    @audio_visual = AudioVisual
      .includes(:user)
      .joins(:user)
      .where(id: params[:id])
      .first

    if !@audio_visual.nil?
      @comments = Comment
        .includes(:user)
        .joins(:user)
        .where(audio_visual_id: @audio_visual.id)
        .paginate(page: params[:page])
        .order("COALESCE(comments.reply_updated_at, comments.updated_at) DESC")
    end

    render layout: false
  end

  # GET /av/1
  def show
    @critiques = AudioVisual
      .includes(critiques: :user)
      .joins(critiques: :user)
      .where(id: @audio_visual.id)

    # Determine if the current user can add a critique to the audio visual.
    has_critique = (@critiques.count { |c| c.user_id == current_user.id } > 0)
    @can_critique = (!has_critique and @contributor and !@owner)
  end

  # GET /av/new
  def new
    @audio_visual = AudioVisual.new
    @audio_visual.round = @round
  end

  # GET /av/1/edit
  def edit
  end

  # POST /av
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

  # PUT /av/1
  def update
    if @audio_visual.update_attributes(params[:audio_visual])
      redirect_to @audio_visual, notice: I18n.t("audio_visual.update.success")
    else
      render action: "edit"
    end
  end

  # DELETE /av/1
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
    @contributor = false

    @audio_visual = AudioVisual
      .includes(round: { folio: :organisation })
      .where(id: params[:id]).first

    if !@audio_visual.nil?
      @owner = (@audio_visual.user_id == current_user.id)

      if !@audio_visual.round_id.nil?
        membership = current_user.organisation_membership_summary(
          @audio_visual.round.folio.organisation, @audio_visual.round.folio)

        if (!membership.nil? and
            (membership[:organisation_admin] or membership[:folio_member]))
          @contributor = (membership[:folio_role] >= 2)
          redirect = false
        end
      else
        # Audio visual does not belong to a folio so allow access.
        redirect = false
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
    round_id = nil

    if !params[:rid].nil? or !params[:audio_visual].nil?
      round_id = params[:rid] ? params[:rid] : params[:audio_visual][:round_id]
    elsif !params[:id].nil?
      av = AudioVisual.find_by_id(params[:id])
      round_id = av.round_id if !av.nil?
    end

    if !round_id.nil?
      @round = Round
        .includes(folio: :organisation)
        .joins(folio: :organisation)
        .where(id: round_id).first

      if !@round.nil?
        membership = current_user.organisation_membership_summary(
          @round.folio.organisation, @round.folio)

        if !membership.nil? and
           (membership[:organisation_admin] or membership[:folio_role] >= 2)
          redirect = false
          @audio_visual_categories = 
            @round.folio.organisation.audio_visual_categories.order(:name).all
        end
      end
    end

    redirect_to root_url if redirect
  end

  # Ensures the current user is the owner of the audio visual.
  #
  def ensure_av_owner
    owner = false
    @audio_visual = AudioVisual
      .includes(:user, round: { folio: :organisation })
      .joins(:user, round: { folio: :organisation })
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
             (membership[:organisation_admin] or membership[:folio_role] == 3)
            owner = true
          end
        end
      end
    end

    redirect_to root_url if !owner
  end
end
