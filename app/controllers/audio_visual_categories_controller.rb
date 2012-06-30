class AudioVisualCategoriesController < ApplicationController 
  helper_method :category, :categories, :organisation

  authority_action({
    index: 'manage',
    new: 'manage',
    edit: 'manage',
    create: 'manage',
    update: 'manage',
    destroy: 'manage'
  })

  # GET /audio_visual_categories
  def index
    authorize_action_for(organisation)
  end

  # GET /audio_visual_categories/new
  def new
    authorize_action_for(organisation)
    @category = categories.build
  end

  # GET /audio_visual_categories/1/edit
  def edit
    authorize_action_for(organisation)
  end

  # POST /audio_visual_categories
  def create
    @category = AudioVisualCategory.new(params[:audio_visual_category])
    authorize_action_for(organisation)

    if @category.save
      redirect_to(
        audio_visual_categories_path(oid: organisation.id),
        notice: I18n.t("audio_visual_category.create.success"))
    else
      render action: "new"
    end
  end

  # PUT /audio_visual_categories/1
  def update
    authorize_action_for(organisation)

    if category.update_attributes(params[:audio_visual_category])
      redirect_to(
        audio_visual_categories_path(oid: organisation.id),
        notice: I18n.t("audio_visual_category.update.success"))
    else
      render action: "edit"
    end
  end

  # DELETE /audio_visual_categories/1
  def destroy
    authorize_action_for(organisation)

    begin
      category.destroy
      redirect_to(
        audio_visual_categories_path(oid: organisation.id),
        notice: I18n.t("audio_visual_category.delete.success"))
    rescue ActiveRecord::DeleteRestrictionError
      redirect_to(
        audio_visual_categories_path(oid: organisation.id),
        alert: I18n.t("audio_visual_category.delete.failure.foreign_key"))
    end
  end

  private
  # Gets the audio visual category being operated on.
  #
  def category
    @category ||= AudioVisualCategory.find(params[:id])
  end

  # Gets the organisation of the audio visual category.
  #
  # This is primarily required for the index and new actions when no
  # audio visual category exists.
  #
  def organisation
    @organisation ||=
      params[:oid] ? Organisation.find(params[:oid]) : category.organisation
  end

  # Gets the existing audio visual categories for the organisation.
  #
  def categories
    @categories ||= organisation.audio_visual_categories.order(:name)
  end
end
