class CritiquesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_folio_contributor, only: [:new, :create]
  before_filter :ensure_critique_author, only: [:edit, :update, :destroy]

  # GET /critiques/new
  def new
    @critique = Critique.new
    @critique.audio_visual = @audio_visual

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
      redirect_to @audio_visual, notice: I18n.t("critique.create.success")
    else
      render action: "new"
    end
  end

  # PUT /critiques/1
  def update
    if @critique.update_attributes(params[:critique])
      redirect_to audio_visual_path(@critique.audio_visual_id), notice: I18n.t("critique.update.success")
    else
      render action: "edit"
    end
  end

  # DELETE /critiques/1
  def destroy
    @critique.destroy

    redirect_to @critique.audio_visual_id, notice: I18n.t("critique.delete.success")
  end

  private
  # Ensures the current user is a contributor of the folio of the supplied
  # round. At this stage if no round is supplied no contributions to the
  # site can be made.
  #
  def ensure_folio_contributor
    redirect = true
    av_id = params[:avid] ? params[:avid] : params[:critique][:audio_visual_id]

    @audio_visual = AudioVisual
      .includes(round: {folio: :organisation})
      .joins(round: {folio: :organisation})
      .where(id: av_id).first

    if !@audio_visual.nil?
      # Ensure the owner of the audio visual cannot submit a critique.
      if @audio_visual.user_id != current_user.id
        organisation = @audio_visual.round.folio.organisation
        membership = current_user.organisation_membership_summary(
          organisation, @audio_visual.round.folio)

        if !membership.nil? and membership[:folio_role] >= 2
          redirect = false

          @categories = CritiqueCategory.categories_for_organisation(organisation)
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
      .includes(critique_components: :critique_category)
      .joins(critique_components: :critique_category)
      .order("critique_components.id")
      .where(id: params[:id]).first

    if !@critique.nil? and @critique.user_id == current_user.id
      redirect = false
    end

    redirect_to root_url if redirect
  end
end
