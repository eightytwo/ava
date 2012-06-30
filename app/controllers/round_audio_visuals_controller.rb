class RoundAudioVisualsController < ApplicationController
  require 'vimeo_helper.rb'

  helper_method :round_audio_visual, :round, :folio, :organisation,
                :audio_visual

  authority_action({
    new: 'contribute',
    edit: 'manage',
    create: 'contribute',
    update: 'manage',
    destroy: 'manage',
    get_upload_ticket: 'contribute',
    complete_upload: 'contribute'
  })

  # GET /rav/show
  def show
    authorize_action_for(round_audio_visual)

    # Get the actual audio visual.
    @audio_visual = round_audio_visual.audio_visual

    # Set the flags indicating if critiques and comments can be shown.
    @show_comments = current_user.can_read?(folio) and
                     round_audio_visual.allow_commenting
    @show_critiques = (current_user.can_contribute?(folio) or
                       current_user.can_manage?(organisation)) and
                      round_audio_visual.allow_critiquing
  end

  # GET /rav/new
  def new
    authorize_action_for(folio)

    @round_audio_visual = RoundAudioVisual.new(round_id: round.id)
    @audio_visual = AudioVisual.new
    round_audio_visual.audio_visual = @audio_visual
  end

  # GET /rav/1/edit
  def edit
    authorize_action_for(round_audio_visual)
  end

  # POST /rav
  def create
    @round_audio_visual = RoundAudioVisual.new(params[:round_audio_visual])
    round_audio_visual.audio_visual.user_id = current_user.id

    authorize_action_for(folio)

    if round.open?
      if round_audio_visual.save
        redirect_to(
          round_audio_visual,
          notice: I18n.t("audio_visual.create.success"))
      else
        render action: :new
      end
    end
  end

  # PUT /rav/1
  def update
    authorize_action_for(round_audio_visual)

    if round_audio_visual.update_attributes(params[:round_audio_visual])
      redirect_to(
        round_audio_visual,
        notice: I18n.t("audio_visual.update.success"))
    else
      render action: :edit
    end
  end

  # DELETE /rav/1
  def destroy
    authorize_action_for(round_audio_visual)

    if round_audio_visual.destroy
      redirect_to root_url
    end
  end

  # GET /rav/get_ticket?rid=1
  def get_upload_ticket
    authorize_action_for(folio)

    ticket = VimeoHelper.get_upload_ticket()

    respond_to do |format|
      format.json { render json: ticket }
    end
  end

  # GET /rav/upload_complete?rid=1&ticket_id=X&filename=Y
  def complete_upload
    authorize_action_for(folio)

    result = VimeoHelper.complete_upload(params[:ticket_id], params[:filename])

    respond_to do |format|
      format.json { render json: result }
    end
  end

  private
  # Gets the round audio visual being operated on.
  #
  def round_audio_visual
    @round_audio_visual ||= RoundAudioVisual.find(params[:id])
  end

  # Gets the round to which the round audio visual belongs.
  #
  def round
    @round ||=
      params[:rid] ? Round.find(params[:rid]) : round_audio_visual.round
  end

  # Gets the folio to which the round belongs.
  #
  def folio
    @folio ||= round.folio
  end

  # Gets the organisation to which the folio belongs.
  #
  def organisation
    @organisation ||= folio.organisation
  end
end
