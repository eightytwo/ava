class AudioVisualsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_av_owner, only: [:edit, :update, :destroy]

  # GET /av/1
  def show
    @audio_visual = AudioVisual
      .includes(:user)
      .joins(:user)
      .where(id: params[:id]).first

    if !@audio_visual.nil? and
      (@audio_visual.public or @audio_visual.user_id == current_user.id)
      # Set a flag indicating if the current user is the owner of the av.
      @owner = (@audio_visual.user_id == current_user.id)

      # Set the flags indicating if comments can be shown and added.
      @show_comments = true
      @can_comment = @audio_visual.allow_commenting
    else
      redirect_to root_url
    end
  end

  # GET /av/new
  def new
    @audio_visual = AudioVisual.new
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
        # Send out a notification to the members of the folio.
        @round.folio.users.each do |recipient|
          # Skip the current user, they know they've added a new AV.
          next if recipient.id == current_user.id
          
          AudioVisualMailer.new_audio_visual(
            recipient, @audio_visual, @round, current_user
          ).deliver
        end
        
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
    if @audio_visual.destroy
      redirect_to root_url, notice: I18n.t("audio_visual.delete.success")
    else
      redirect_to root_url, notice: I18n.t("audio_visual.delete.success")
    end
  end

  private
  # Ensures the current user is the owner of the audio visual.
  #
  def ensure_av_owner
    owner = false
    @audio_visual = AudioVisual
      .includes(:user)
      .joins(:user)
      .where(id: params[:id]).first

    if !@audio_visual.nil?
      owner = true if @audio_visual.user_id == current_user.id
    end

    redirect_to root_url if !owner
  end
end
