class AudioVisualsController < ApplicationController
  #skip_before_filter :authenticate_user!, only: :show

  helper_method :audio_visual

  authority_action({
    new: 'manage',
    edit: 'manage',
    create: 'manage',
    update: 'manage',
    destroy: 'manage'
  })

  # GET /av/1
  def show
    @audio_visual = AudioVisual
      .includes(:user)
      .joins(:user)
      .where(id: params[:id]).first

    authorize_action_for(audio_visual)
  end

  # GET /av/new
  def new
    @audio_visual = AudioVisual.new(user_id: current_user.id)
    authorize_action_for(audio_visual)
  end

  # GET /av/1/edit
  def edit
    authorize_action_for(audio_visual)
  end

  # POST /av
  def create
    @audio_visual = AudioVisual.new(params[:audio_visual])
    @audio_visual.user_id = current_user.id

    authorize_action_for(audio_visual)

    if audio_visual.save        
      redirect_to audio_visual, notice: I18n.t("audio_visual.create.success")
    else
      render action: :new
    end
  end

  # PUT /av/1
  def update
    authorize_action_for(audio_visual)

    if audio_visual.update_attributes(params[:audio_visual])
      redirect_to audio_visual, notice: I18n.t("audio_visual.update.success")
    else
      render action: :edit
    end
  end

  # DELETE /av/1
  def destroy
    authorize_action_for(audio_visual)

    if audio_visual.destroy
      redirect_to root_url, notice: I18n.t("audio_visual.delete.success")
    else
      redirect_to root_url, notice: I18n.t("audio_visual.delete.success")
    end
  end

  private
  # Gets the audio visual being operated on.
  #
  def audio_visual
    @audio_visual ||= AudioVisual.find(params[:id])
  end
end
