class CritiqueCategoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_organisation_admin

  # GET /critique_categories
  def index
    @categories = CritiqueCategory.categories_for_organisation(@organisation)
  end

  # GET /critique_categories/new
  def new
    @category = CritiqueCategory.new
    @category.organisation = @organisation
  end

  # GET /critique_categories/1/edit
  def edit
  end

  # POST /critique_categories
  def create
    @category = CritiqueCategory.new(params[:critique_category])

    if @category.save
      redirect_to critique_categories_path(oid: @organisation.id), notice: I18n.t("critique_category.create.success")
    else
      render action: "new"
    end
  end

  # PUT /critique_categories/1
  def update
    if @category.update_attributes(params[:critique_category])
      redirect_to critique_categories_path(oid: @organisation.id), notice: I18n.t("critique_category.update.success")
    else
      render action: "edit"
    end
  end

  # DELETE /critique_categories/1
  def destroy
    begin
      @category.destroy
      redirect_to critique_categories_path(oid: @organisation.id),
        notice: I18n.t("critique_category.delete.success")
    rescue ActiveRecord::DeleteRestrictionError => e
      redirect_to critique_categories_path(oid: @organisation.id),
        alert: I18n.t("critique_category.delete.failure.foreign_key")
    end
  end

  private
  # Ensures the current user is an administrator of the requested
  # organisation.
  #
  def ensure_organisation_admin
    is_admin = false

    # Get the category.
    @category = CritiqueCategory.find_by_id(params[:id])

    # The category will be nil if a new one is being created.
    if @category.nil?
      organisation_id = !params[:oid].nil? ? params[:oid] : params[:critique_category][:organisation_id]
      @organisation = Organisation.find_by_id(organisation_id)
    else
      @organisation = @category.organisation
    end

    # Ensure an organisation was found.
    if !@organisation.nil?
      # Get the organisation user record for the current user.
      organisation_user = OrganisationUser.find_by_organisation_and_user(
        @organisation, current_user)

      # Check if the current user is an administrator of the organisation.
      is_admin = true if !organisation_user.nil? and organisation_user.admin
    end

    redirect_to root_url if !is_admin
  end
end
