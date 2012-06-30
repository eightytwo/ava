class CritiquesController < ApplicationController
  helper_method :critique, :categories, :round_audio_visual, :organisation

  authority_action({ new: 'critique', create: 'critique' })

  # GET /critiques?ravid=1
  def index
    @critique = round_audio_visual.critiques.build
    authorize_action_for(@critique)

    @critiques = Critique
      .includes(critique_components: :critique_category)
      .joins(critique_components: :critique_category)
      .where(round_audio_visual_id: round_audio_visual.id)
      .order("critiques.updated_at DESC, critique_components.id ASC")

    respond_to do |format|
      format.js { @critiques }
    end
  end

  # GET /critiques/new
  def new
    @critique = round_audio_visual.critiques.build
    authorize_action_for(round_audio_visual)

    categories.each do |category|
      critique.critique_components.build({
        critique_category: category[:category]
      })
    end
  end

  # GET /critiques/1/edit
  def edit
    authorize_action_for(critique)
  end

  # POST /critiques
  def create
    @critique = Critique.new(params[:critique])
    critique.user = current_user

    authorize_action_for(round_audio_visual)

    if critique.save
      redirect_to round_audio_visual, notice: I18n.t("critique.create.success")
    else
      render action: "new"
    end
  end

  # PUT /critiques/1
  def update
    authorize_action_for(critique)

    if critique.update_attributes(params[:critique])
      redirect_to(
        round_audio_visual_path(round_audio_visual),
        notice: I18n.t("critique.update.success"))
    else
      render action: "edit"
    end
  end

  # DELETE /critiques/1
  def destroy
    authorize_action_for(critique)
    critique.destroy
    redirect_to(round_audio_visual, notice: I18n.t("critique.delete.success"))
  end

  private
  # Gets the critique being operated on.
  #
  def critique
    @critique ||= Critique.find(params[:id])
  end

  # Gets the critique categories for the organisation.
  #
  def categories
    @categories ||= CritiqueCategory.categories_for_organisation(organisation)
  end

  # Gets the round audio visual of the critique.
  #
  def round_audio_visual
    @round_audio_visual ||=
      params[:ravid] ? RoundAudioVisual.find(params[:ravid]) : critique.round_audio_visual
  end

  # Gets the organisation of the round audio visual.
  #
  def organisation
    @organisation ||= round_audio_visual.round.folio.organisation
  end
end
