class AudioVisualCategoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_organisation_admin
  before_filter :get_categories, except: [:new, :edit]

  # GET /audio_visual_categories
  def index
  end

  # GET /audio_visual_categories/new
  def new
    @category = AudioVisualCategory.new
    @category.organisation = @organisation
  end

  # GET /audio_visual_categories/1/edit
  def edit
  end

  # POST /audio_visual_categories
  def create
    @category = AudioVisualCategory.new(params[:audio_visual_category])
    if @category.save
      redirect_to audio_visual_categories_path(oid: @organisation.id), notice: I18n.t("audio_visual_category.create.success")
    else
      render action: "new"
    end
  end

  # PUT /audio_visual_categories/1
  def update
    if @category.update_attributes(params[:audio_visual_category])
      redirect_to audio_visual_categories_path(oid: @organisation.id), notice: I18n.t("audio_visual_category.update.success")
    else
      render action: "edit"
    end
  end

  # DELETE /audio_visual_categories/1
  def destroy
    begin
      @category.destroy
      redirect_to audio_visual_categories_path(oid: @organisation.id), notice: I18n.t("audio_visual_category.delete.success")
    rescue ActiveRecord::DeleteRestrictionError
      redirect_to audio_visual_categories_path(oid: @organisation.id), alert: I18n.t("audio_visual_category.delete.failure.foreign_key")
    end
  end

  private
  # Ensures the current user is an administrator of the requested
  # organisation.
  #
  def ensure_organisation_admin
    is_admin = false

    # Get the category.
    @category = AudioVisualCategory.find_by_id(params[:id])

    # The category will be nil if a new one is being created.
    if @category.nil?
      organisation_id = !params[:oid].nil? ? params[:oid] : params[:audio_visual_category][:organisation_id]
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

  # Gets the existing audio visual categories for the organisation.
  #
  def get_categories
    @categories = AudioVisualCategory
      .where(organisation_id: @organisation.id)
      .order(:name)
      .all
  end
end
