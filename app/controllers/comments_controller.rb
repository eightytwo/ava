class CommentsController < ApplicationController
  helper_method :comment, :commentable, :comments

  authority_action({
    new: 'comment',
    create: 'comment',
    reply: 'comment'
  })

  # POST /comments/reply
  def reply
    authorize_action_for(commentable)

    # Ensure the current user can update comments for the resource.
    if comment and commentable.user == current_user
      @comment.reply = params[:reply_content]
      @comment.update_record_without_timestamping
    end
  end

  # GET /comments
  def index
    authorize_action_for(commentable)
    @comment = commentable.comments.new
    @form_title = I18n.t("comment.new.title")
  end

  # GET /comments/1/edit
  def edit
    authorize_action_for(comment)
    @form_title = I18n.t("comment.edit.title")
  end

  # POST /comments
  def create
    authorize_action_for(commentable)
    @comment = commentable.comments.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.save
  end

  # PUT /comments/1
  def update
    authorize_action_for(comment)

    # Update the comment content.
    comment.content = params[:comment][:content]
    comment.save
    @comment = commentable.comments.new
    @form_title = I18n.t("comment.new.title")
  end

  private
  # Gets the comment being operated on.
  #
  def comment
    @comment ||= Comment.find(params[:id])
  end

  # Gets the resource which is the subject of the commenting.
  #
  def commentable
    if @commentable
      return @commentable
    else
      if params[:id]
        @commentable = comment.commentable_type.classify.constantize.find(
          comment.commentable_id)
      else
        resource, id = request.path.split('/')[1, 2]
        @commentable = resource.singularize.classify.constantize.find(id)  
      end
    end
  end

  # Retrieves a collection of comments.
  #
  def comments
    @comments ||= @commentable.comments
      .includes(:user)
      .joins(:user)
      .paginate(page: params[:page])
      .order("GREATEST(comments.reply_updated_at, comments.updated_at) DESC")
  end
end
