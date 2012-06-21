class CritiquesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_view_index, only: :index
  before_filter :ensure_folio_contributor, only: [:new, :create]
  before_filter :ensure_critique_author, only: [:edit, :update, :destroy]

  # GET /critiques?ravid=1
  def index
    if @can_view
      @critiques = Critique
        .includes(critique_components: :critique_category)
        .joins(critique_components: :critique_category)
        .where(round_audio_visual_id: @round_audio_visual.id)
        .order("critiques.updated_at DESC, critique_components.id ASC")

      respond_to do |format|
        format.js { @critiques }
      end
    end
  end

  # GET /critiques/new
  def new
    @critique = Critique.new
    @critique.round_audio_visual = @round_audio_visual

    @categories.each do |category|
      @critique.critique_components.build({
        critique_category: category[:category]
      })
    end
  end

  # GET /critiques/1/edit
  def edit
  end

  # POST /critiques
  def create
    @critique = Critique.new(params[:critique])
    @critique.user = current_user

    if @critique.save
      # Send a notification to the audio visual owner that a critique has
      # posted.
      CritiqueMailer.new_critique(
        @round_audio_visual.audio_visual.user,
        @round_audio_visual.audio_visual,
        current_user
      ).deliver
      
      redirect_to @round_audio_visual, notice: I18n.t("critique.create.success")
    else
      render action: "new"
    end
  end

  # PUT /critiques/1
  def update
    if @critique.update_attributes(params[:critique])
      # Send a notification to the audio visual owner that a critique has
      # updated.
      CritiqueMailer.updated_critique(
        @critique.round_audio_visual.audio_visual.user,
        @critique.round_audio_visual.audio_visual,
        current_user
      ).deliver

      redirect_to(round_audio_visual_path(@critique.round_audio_visual_id),
        notice: I18n.t("critique.update.success"))
    else
      render action: "edit"
    end
  end

  # DELETE /critiques/1
  def destroy
    @critique.destroy

    redirect_to(@critique.round_audio_visual_id,
      notice: I18n.t("critique.delete.success"))
  end

  private
  # Ensures the current user can view critiques for an audio visual.
  #
  def ensure_view_index
    @can_view = false
    rav_id = params[:ravid] ? params[:ravid] : params[:critique][:round_audio_visual_id]

    @round_audio_visual = RoundAudioVisual
      .includes(round: {folio: :organisation})
      .joins(round: {folio: :organisation})
      .where(id: rav_id).first

    if !@round_audio_visual.nil?
      organisation = @round_audio_visual.round.folio.organisation
      membership = current_user.organisation_membership_summary(
        organisation, @round_audio_visual.round.folio)

      if !membership.nil? and 
        (membership[:organisation_admin] or membership[:folio_role] >= 2)
        @can_view = true
        @categories = CritiqueCategory.categories_for_organisation(organisation)
      end
    end
  end

  # Ensures the current user is a contributor of the folio of the supplied
  # round. At this stage if no round is supplied no contributions to the
  # site can be made.
  #
  def ensure_folio_contributor
    redirect = true
    rav_id = params[:ravid] ? params[:ravid] : params[:critique][:round_audio_visual_id]

    @round_audio_visual = RoundAudioVisual
      .includes(:audio_visual, round: {folio: :organisation})
      .joins(:audio_visual, round: {folio: :organisation})
      .where(id: rav_id).first

    if !@round_audio_visual.nil?
      # Ensure the owner of the audio visual cannot submit a critique.
      if @round_audio_visual.audio_visual.user_id != current_user.id
        organisation = @round_audio_visual.round.folio.organisation
        membership = current_user.organisation_membership_summary(
          organisation, @round_audio_visual.round.folio)

        if !membership.nil? and membership[:folio_role] >= 2
          redirect = false

          @categories = CritiqueCategory.categories_for_organisation(
            organisation)
        end
      end
    end

    redirect_to root_url if redirect
  end

  # Ensures the current user is the author of the critique.
  #
  def ensure_critique_author
    redirect = true
    
    # Get the critique in question and its components.
    @critique = Critique
      .includes(:round_audio_visual, critique_components: :critique_category)
      .joins(:round_audio_visual, critique_components: :critique_category)
      .order("critique_components.id")
      .where(id: params[:id]).first

    if !@critique.nil? and @critique.user_id == current_user.id
      redirect = false
    end

    redirect_to root_url if redirect
  end
end
