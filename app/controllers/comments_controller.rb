class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_folio_member, except: :reply

  # POST /comments/reply
  def reply
    # Get the comment (and its audio visual).
    if !params[:component_id].nil?
      @comment = Comment
        .includes(:audio_visual)
        .joins(:audio_visual)
        .where(id: params[:component_id])
        .first

      # Only proceed with adding the reply if the current user is the
      # author of the audio visual.
      if !@comment.nil? and
         @comment.audio_visual.user_id == current_user.id
        
        # Set the reply content and save.
        @comment.reply = params[:reply_content]
        @comment.update_record_without_timestamping
        
        respond_to do |format|
          format.js { @comment }
        end
      end
    end
  end

  # GET /comments?avid=1
  def index
    if (@folio_member or @organisation_admin) and !@audio_visual.nil?
      # Prepare a new comment for the form and set the form title.
      @comment = Comment.new
      @comment.audio_visual_id = @audio_visual.id
      @form_title = I18n.t("audio_visual.show.comment_form.titles.add")

      # Fetch the most recent comments.
      @comments = fetch_comments
    end
  end

  # GET /comments/1/edit
  def edit
    @form_title = I18n.t("audio_visual.show.comment_form.titles.edit")
  end

  # POST /comments
  def create
    if @folio_member
      @comment = Comment.new(params[:comment])
      @comment.user_id = current_user.id
      
      if @comment.save
        # Send a notification to the audio visual owner that a critique has
        # posted.
        if current_user.id != @audio_visual.user.id
          CommentMailer.new_comment(
            @audio_visual.user, @audio_visual, current_user
          ).deliver
        end

        # Fetch the latest comments.
        @comments = fetch_comments
      end
    end
  end

  # PUT /comments/1
  def update
    if @folio_member
      if @comment.update_attributes(params[:comment])
        # Send a notification to the audio visual owner that a critique has
        # posted.
        if current_user.id != @audio_visual.user.id
          CommentMailer.updated_comment(
            @audio_visual.user, @audio_visual, current_user
          ).deliver
        end

        # Fetch the latest comments.
        @comments = fetch_comments
        
        # Setup a new comment.
        @comment = Comment.new
        @comment.audio_visual_id = @audio_visual.id
        @form_title = I18n.t("audio_visual.show.comment_form.titles.add")
      end
    end
  end

  private
  # Fetches a batch of comments to display.
  #
  def fetch_comments
    @comments = Comment
      .includes(:user)
      .joins(:user)
      .where(audio_visual_id: @audio_visual.id)
      .paginate(page: params[:page])
      .order("COALESCE(comments.reply_updated_at, comments.updated_at) DESC")
  end

  # Ensures the current user is a member of the folio of the audio visual.
  #
  def ensure_folio_member
    av_id = nil
    @folio_member = false

    if !params[:id].nil?
      @comment = Comment.find_by_id(params[:id])
      av_id = @comment.audio_visual_id if !@comment.nil?
    else
      av_id = params[:avid] ? params[:avid] : params[:comment][:audio_visual_id]
    end

    if !av_id.nil?
      @audio_visual = AudioVisual
        .includes(round: { folio: :organisation })
        .where(id: av_id).first

      if !@audio_visual.nil?
        if !@audio_visual.round_id.nil?
          membership = current_user.organisation_membership_summary(
            @audio_visual.round.folio.organisation, @audio_visual.round.folio)

          if (!membership.nil?)
            @folio_member = membership[:folio_member]
            @organisation_admin = membership[:organisation_admin]
          end
        end
      end
    end
  end
end
