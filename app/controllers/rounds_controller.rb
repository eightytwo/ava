class RoundsController < ApplicationController
  helper_method :round, :folio, :organisation

  authority_action({
    new: 'manage',
    edit: 'manage',
    create: 'manage',
    update: 'manage',
    destroy: 'manage'
  })

  # GET /rounds/1
  def show
    authorize_action_for(folio)

    @round_audio_visuals = RoundAudioVisual
      .includes(audio_visual: :user)
      .joins(audio_visual: :user)
      .where(round_id: round.id)
      .paginate(page: params[:page])
      .order("audio_visuals.created_at DESC")
  end

  # GET /rounds/new
  def new
    authorize_action_for(folio)
    @round = folio.rounds.build
  end

  # GET /rounds/1/edit
  def edit
    authorize_action_for(folio)
  end

  # POST /rounds
  def create
    @round = Round.new(params[:round])
    authorize_action_for(folio)

    if round.save
      redirect_to round, notice: I18n.t("round.create.success")
    else
      render action: :new
    end
  end

  # PUT /rounds/1
  def update
    authorize_action_for(folio)

    if round.update_attributes(params[:round])
      redirect_to folio, notice: I18n.t("round.update.success")
    else
      render action: :edit
    end
  end

  # DELETE /rounds/1
  def destroy
    round.destroy
    redirect_to folio, notice: I18n.t("round.delete.success")
  end

  private
  # Gets the round being operated on.
  #
  def round
    @round ||= Round.find(params[:id])
  end

  # Gets the folio of the round.
  #
  # This is primarily required for the new action when no round exists.
  #
  def folio
    @folio ||= params[:fid] ? Folio.find(params[:fid]) : round.folio
  end

  # Gets the organisation of the folio.
  #
  def organisation
    @organisation ||= folio.organisation
  end
end
