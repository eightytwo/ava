class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_commentable, except: [:edit, :reply]
  before_filter :load_commentable_for_edit, only: [:edit, :reply]

  # POST /comments/reply
  def reply
    # Ensure the current user can update comments for the resource.
    if @commentable.accepts_comments_from?(current_user)
      @comment = @commentable.comments.find_by_id(params[:id])

      if !@comment.nil? and @commentable.user.id == current_user.id
        @comment.reply = params[:reply_content]
        @comment.update_record_without_timestamping

        respond_to do |format|
          format.js { @comment }
        end
      end
    end
  end

  # GET /comments
  def index
    if @commentable.comments_visible_to?(current_user)
      @comments = fetch_comments
      @comment = @commentable.comments.new
      @form_title = I18n.t("comment.new.title")
    end
  end

  # GET /comments/1/edit
  def edit
    @form_title = I18n.t("comment.edit.title")
  end

  # POST /comments
  def create
    if @commentable.accepts_comments_from?(current_user)
      @comment = @commentable.comments.new(params[:comment])
      @comment.user_id = current_user.id

      if @comment.save
        # Notify the owner of the resource that a comment has been added.
        if @commentable.respond_to?(:send_new_comment_notification)
          @commentable.send_new_comment_notification(current_user)
        end
        # Fetch the latest comments.
        @comments = fetch_comments
      end
    end
  end

  # PUT /comments/1
  def update
    # Ensure the current user can update comments for the resource.
    if @commentable.accepts_comments_from?(current_user)
      @comment = @commentable.comments.find_by_id(params[:id])

      if !@comment.nil? and @comment.user_id == current_user.id
        if @comment.update_attributes(params[:comment])
          # Notify the owner of the resource that a comment has been updated.
          if @commentable.respond_to?(:send_updated_comment_notification)
            @commentable.send_updated_comment_notification(current_user)
          end

          # Fetch the latest comments and setup a new comment.
          @comments = fetch_comments
          @comment = @commentable.comments.new
          @form_title = I18n.t("comment.new.title")
        end
      end
    end
  end

  private
  # Loads the resource which is being queried in the context of its
  # comments.
  #
  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  # Loads the resource for which a comment is being edited.
  # The load_commentable method cannot be used as the edit comment form
  # is generic for all commentable resources and therefore the edit path
  # does not contain information about the resource type.
  #
  def load_commentable_for_edit
    @comment = Comment.find_by_id(params[:id])
    if !@comment.nil?
      @commentable = @comment.commentable_type.classify.constantize.find(
        @comment.commentable_id
      )
    end
  end

  # Fetches a batch of comments to display.
  #
  def fetch_comments
    @commentable.comments
      .includes(:user)
      .joins(:user)
      .paginate(page: params[:page])
      .order("GREATEST(comments.reply_updated_at, comments.updated_at) DESC")
  end
end
