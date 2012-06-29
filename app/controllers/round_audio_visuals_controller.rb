class RoundAudioVisualsController < ApplicationController
  require 'vimeo_helper.rb'

  before_filter :ensure_folio_member, only: :show
  before_filter :ensure_av_owner, only: [:edit, :update, :destroy]
  before_filter :ensure_folio_contributor, only: [:new, :create, :get_ticket, :upload_complete]

  # GET /rav/show
  def show
    @audio_visual = @round_audio_visual.audio_visual

    # Set the flags indicating if critiques and comments can be shown.
    @show_comments = 
      ((@folio_member or @organisation_admin) and
       @round_audio_visual.allow_commenting)
    @show_critiques = 
      ((@contributor or @organisation_admin) and
       @round_audio_visual.allow_critiquing)

    # Determine if the current user can add a critique to the audio visual.
    has_critiqued = Critique.where("round_audio_visual_id = ? and user_id = ?",
      @round_audio_visual.id, current_user.id).count > 0
    
    @can_critique = (
      @round_audio_visual.allow_critiquing and
      !has_critiqued and
      @contributor and
      !@owner)

    # Determine if the current user can add a comment.
    @can_comment = (@round_audio_visual.allow_commenting and @folio_member)
  end

  # GET /rav/new
  def new
    @round_audio_visual = RoundAudioVisual.new
    @audio_visual = AudioVisual.new
    @round_audio_visual.audio_visual = @audio_visual
    @round_audio_visual.round = @round
  end

  # GET /rav/1/edit
  def edit
  end

  # POST /rav
  def create
    if @round.nil? or (!@round.nil? and @round.open?)
      @round_audio_visual = RoundAudioVisual.new(params[:round_audio_visual])
      @round_audio_visual.audio_visual.user_id = current_user.id

      if @round_audio_visual.save
        audio_visual = @round_audio_visual.audio_visual
        # Send out a notification to the members of the folio.
        @round.folio.users.each do |recipient|
          # Skip the current user, they know they've added a new AV.
          next if recipient.id == current_user.id
          
          RoundAudioVisualMailer.new_audio_visual(
            recipient, @round_audio_visual, audio_visual, @round, current_user
          ).deliver
        end
        
        redirect_to @round_audio_visual, notice: I18n.t("audio_visual.create.success")
      else
        render action: "new"
      end
    end
  end

  # PUT /rav/1
  def update
    if @round_audio_visual.update_attributes(params[:round_audio_visual])
      redirect_to @round_audio_visual, notice: I18n.t("audio_visual.update.success")
    else
      render action: "edit"
    end
  end

  # DELETE /rav/1
  def destroy
    if @round_audio_visual.destroy
      redirect_to root_url
    end
  end

  # GET /rav/get_ticket?rid=1
  def get_upload_ticket
    ticket = VimeoHelper.get_upload_ticket()

    respond_to do |format|
      format.json { render json: ticket }
    end
  end

  # GET /rav/upload_complete?rid=1&ticket_id=X&filename=Y
  def complete_upload
    result = VimeoHelper.complete_upload(params[:ticket_id], params[:filename])

    respond_to do |format|
      format.json { render json: result }
    end
  end

  private
  # Ensures the current user is a member of the folio to which this audio
  # visual belongs or is an administrator of the organisation to which this
  # audio visual ultimately belongs.
  #
  def ensure_folio_member
    redirect = true
    @round_audio_visual = RoundAudioVisual
      .includes(:audio_visual, round: { folio: :organisation })
      .joins(:audio_visual, round: { folio: :organisation })
      .where(id: params[:id]).first

    if !@round_audio_visual.nil?
      @owner = (@round_audio_visual.audio_visual.user_id == current_user.id)

      membership = current_user.organisation_membership_summary(
        @round_audio_visual.round.folio.organisation,
        @round_audio_visual.round.folio)

      if (!membership.nil? and
          (membership[:organisation_admin] or membership[:folio_member]))
        @organisation_admin = membership[:organisation_admin]
        @folio_member = membership[:folio_member]
        @contributor = (membership[:folio_role] >= 2)
        redirect = false
      end
    end

    redirect_to root_url if redirect
  end

  # Ensures the current user is a contributor of the folio of the supplied
  # round. At this stage if no round is supplied no contributions to the
  # site can be made.
  #
  def ensure_folio_contributor
    redirect = true
    round_id = nil

    if !params[:rid].nil? or !params[:round_audio_visual].nil?
      round_id = params[:rid] ? params[:rid] : params[:round_audio_visual][:round_id]
    elsif !params[:id].nil?
      rav = RoundAudioVisual.find_by_id(params[:id])
      round_id = rav.round_id if !rav.nil?
    end

    if !round_id.nil?
      @round = Round
        .includes(folio: :organisation)
        .joins(folio: :organisation)
        .where(id: round_id).first

      if !@round.nil?
        membership = current_user.organisation_membership_summary(
          @round.folio.organisation, @round.folio)

        if !membership.nil? and
           (membership[:organisation_admin] or membership[:folio_role] >= 2)
          redirect = false
          @audio_visual_categories = 
            @round.folio.organisation.audio_visual_categories.order(:name).all
        end
      end
    end

    redirect_to root_url if redirect
  end

  # Ensures the current user is the owner of the audio visual.
  #
  def ensure_av_owner
    owner = false
    @round_audio_visual = RoundAudioVisual
      .includes(audio_visual: :user, round: { folio: :organisation })
      .joins(audio_visual: :user, round: { folio: :organisation })
      .where(id: params[:id]).first

    if !@round_audio_visual.nil? and !@round_audio_visual.round.nil?
      @round = @round_audio_visual.round
      @audio_visual_categories = 
        @round.folio.organisation.audio_visual_categories.order(:name).all

      if @round_audio_visual.audio_visual.user_id == current_user.id
        owner = true
      else
        membership = current_user.organisation_membership_summary(
          @round.folio.organisation, @round.folio)

        if !membership.nil? and
           (membership[:organisation_admin] or membership[:folio_role] == 3)
          owner = true
        end
      end
    end

    redirect_to root_url if !owner
  end
end
