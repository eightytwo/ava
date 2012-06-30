class CritiqueCategoriesController < ApplicationController
  helper_method :category, :categories, :organisation

  authority_action({
    index: 'manage',
    new: 'manage',
    edit: 'manage',
    create: 'manage',
    update: 'manage',
    destroy: 'manage'
  })

  # GET /critique_categories
  def index
    authorize_action_for(organisation)
  end

  # GET /critique_categories/new
  def new
    authorize_action_for(organisation)
    @category = CritiqueCategory.new(organisation_id: organisation.id)
  end

  # GET /critique_categories/1/edit
  def edit
    authorize_action_for(organisation)
  end

  # POST /critique_categories
  def create
    @category = CritiqueCategory.new(params[:critique_category])
    authorize_action_for(organisation)

    if @category.save
      redirect_to(
        critique_categories_path(oid: organisation),
        notice: I18n.t("critique_category.create.success"))
    else
      render action: :new
    end
  end

  # PUT /critique_categories/1
  def update
    authorize_action_for(organisation)

    if category.update_attributes(params[:critique_category])
      redirect_to(
        critique_categories_path(oid: organisation),
        notice: I18n.t("critique_category.update.success"))
    else
      render action: :edit
    end
  end

  # DELETE /critique_categories/1
  def destroy
    authorize_action_for(organisation)

    begin
      category.destroy
      redirect_to(
        critique_categories_path(oid: organisation),
        notice: I18n.t("critique_category.delete.success"))
    rescue ActiveRecord::DeleteRestrictionError => e
      redirect_to(
        critique_categories_path(oid: organisation),
        alert: I18n.t("critique_category.delete.failure.foreign_key"))
    end
  end

  private
  # Gets the critique category being operated on.
  #
  def category
    @category ||= CritiqueCategory.find(params[:id])
  end

  # Gets the organisation of the critique category.
  #
  # This is primarily required for the index and new actions when no
  # critique category exists.
  #
  def organisation
    @organisation ||=
      params[:oid] ? Organisation.find(params[:oid]) : category.organisation
  end

  # Gets the existing audio visual categories for the organisation.
  #
  def categories
    @categories ||= CritiqueCategory.categories_for_organisation(organisation)
  end
end
