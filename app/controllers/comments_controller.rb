class CommentsController < ApplicationController
  helper_method :commentable, :comments

  authority_action({
    new: 'comment',
    edit: 'comment',
    create: 'comment',
    update: 'comment',
    reply: 'comment'
  })

  # POST /comments/reply
  def reply
    # Ensure the current user can update comments for the resource.
    if current_user.can_comment?(commentable)
      if commentable.user == current_user and @comment
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
    if current_user.can_read?(commentable)
      @comment = commentable.comments.new
      @form_title = I18n.t("comment.new.title")
    end
  end

  # GET /comments/1/edit
  def edit
    if current_user.can_comment?(commentable)
      @form_title = I18n.t("comment.edit.title")
    end
  end

  # POST /comments
  def create
    if current_user.can_comment?(commentable)
      @comment = commentable.comments.new(params[:comment])
      @comment.user_id = current_user.id
      @comment.save
    end
  end

  # PUT /comments/1
  def update
    # Ensure the current user can update comments for the resource.
    if current_user.can_comment?(commentable)
      @comment = Comment.find(params[:id])

      if @comment and @comment.user_id == current_user.id
        if @comment.update_attributes(params[:comment])
          @comment = commentable.comments.new
          @form_title = I18n.t("comment.new.title")
        end
      end
    end
  end

  private
  # Gets the resource which is the subject of the commenting.
  #
  def commentable
    if @commentable
      return @commentable
    else
      if params[:id]
        @comment = Comment.find(params[:id])
        @commentable = @comment.commentable_type.classify.constantize.find(
          @comment.commentable_id)
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
