require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Rails.application.routes.url_helpers
  include Devise::TestHelpers

  setup do
    @comment = comments(:haddock_one)
    @rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)
  end

  #
  # :index tests
  #

  test "should get index as folio viewer" do
    sign_in users(:snowy)

    # Set the polymorphic path to allow the CommentsController to
    # derive the commentable object.
    @request.env['PATH_INFO'] = polymorphic_path([@rav, Comment])

    get :index, format: :js
    assert_not_nil assigns(:comments)
  end

  test "should not get index as member of different folio" do
    sign_in users(:calculus)

    # Set the polymorphic path to allow the CommentsController to
    # derive the commentable object.
    @request.env['PATH_INFO'] = polymorphic_path([@rav, Comment])
    
    get :index, format: :js
    assert_response 403
  end

  test "should not get index as member of different organisation" do
    sign_in users(:rastapopoulos)

    # Set the polymorphic path to allow the CommentsController to
    # derive the commentable object.
    @request.env['PATH_INFO'] = polymorphic_path([@rav, Comment])
    
    get :index, format: :js
    assert_response 403
  end

  test "should not get index as member of public" do
    # Set the polymorphic path to allow the CommentsController to
    # derive the commentable object.
    @request.env['PATH_INFO'] = polymorphic_path([@rav, Comment])
    
    get :index, format: :js
    assert_response 401
  end


  #
  # :create tests
  # 

  test "should create comment as folio viewer" do
    sign_in users(:snowy)

    # Set the polymorphic path to allow the CommentsController to
    # derive the commentable object.
    @request.env['PATH_INFO'] = polymorphic_path([@rav, Comment])

    assert_difference('Comment.count') do
      post :create, comment: { content: @comment.content }, format: :js
    end

    assert_not_nil assigns(:comments)
  end

  test "should create comment as commentable owner" do
    sign_in users(:tintin)

    # Set the polymorphic path to allow the CommentsController to
    # derive the commentable object.
    @request.env['PATH_INFO'] = polymorphic_path([@rav, Comment])

    assert_difference('Comment.count') do
      post :create, comment: { content: @comment.content }, format: :js
    end

    assert_not_nil assigns(:comments)
  end

  test "should not create comment as member of different folio" do
    sign_in users(:calculus)

    # Set the polymorphic path to allow the CommentsController to
    # derive the commentable object.
    @request.env['PATH_INFO'] = polymorphic_path([@rav, Comment])

    assert_no_difference('Comment.count') do
      post :create, comment: { content: @comment.content }, format: :js
    end

    assert_response 403
  end

  test "should not create comment as member of different organisation" do
    sign_in users(:rastapopoulos)

    # Set the polymorphic path to allow the CommentsController to
    # derive the commentable object.
    @request.env['PATH_INFO'] = polymorphic_path([@rav, Comment])

    assert_no_difference('Comment.count') do
      post :create, comment: { content: @comment.content }, format: :js
    end

    assert_response 403
  end

  test "should not create comment as member of public" do
    # Set the polymorphic path to allow the CommentsController to
    # derive the commentable object.
    @request.env['PATH_INFO'] = polymorphic_path([@rav, Comment])

    assert_no_difference('Comment.count') do
      post :create, comment: { content: @comment.content }, format: :js
    end

    assert_response 401
  end


  #
  # :edit tests
  #
  
  test "should get edit as owner of comment" do
    sign_in users(:haddock)
    get :edit, id: @comment, format: :js
    assert_response :success
  end

  test "should not get edit as member of folio" do
    sign_in users(:tintin)
    get :edit, id: @comment, format: :js
    assert_response 403
  end

  test "should not get edit as member of different folio" do
    sign_in users(:calculus)
    get :edit, id: @comment, format: :js
    assert_response 403
  end

  test "should not get edit as member of different organisation" do
    sign_in users(:rastapopoulos)
    get :edit, id: @comment, format: :js
    assert_response 403
  end

  test "should not get edit as member of public" do
    get :edit, id: @comment, format: :js
    assert_response 401
  end


  #
  # :update tests
  #

  test "should update comment as comment author" do
    sign_in users(:haddock)
    new_content = "New content for the comment."

    put(
      :update,
      id: @comment,
      comment: { content: new_content },
      format: :js)
    
    assert_equal new_content, Comment.find(@comment).content
  end

  test "should not update comment as member of folio" do
    sign_in users(:tintin)
    new_content = "New content for the comment."

    put(
      :update,
      id: @comment,
      comment: { content: new_content },
      format: :js)
    
    assert_response 403
    assert_not_equal new_content, Comment.find(@comment).content
  end

  test "should not update comment as member of different folio" do
    sign_in users(:calculus)
    new_content = "New content for the comment."

    put(
      :update,
      id: @comment,
      comment: { content: new_content },
      format: :js)
    
    assert_response 403
    assert_not_equal new_content, Comment.find(@comment).content
  end

  test "should not update comment as member of different organisation" do
    sign_in users(:rastapopoulos)
    new_content = "New content for the comment."

    put(
      :update,
      id: @comment,
      comment: { content: new_content },
      format: :js)
    
    assert_response 403
    assert_not_equal new_content, Comment.find(@comment).content
  end

  test "should not update comment as member of public" do
    new_content = "New content for the comment."

    put(
      :update,
      id: @comment,
      comment: { content: new_content },
      format: :js)
    
    assert_response 401
    assert_not_equal new_content, Comment.find(@comment).content
  end


  #
  # :reply tests
  #

  test "should accept reply by owner of commentable" do
    sign_in users(:tintin)
    reply = "Tintin's Reply!"

    post :reply,
      id: @comment,
      reply_content: reply,
      format: :js

    assert_not_nil assigns(:comment)
    assert_equal reply, assigns(:comment).reply
  end

  test "should not accept reply by author of comment" do
    sign_in users(:haddock)
    reply = "A reply to my own comment!"

    post :reply,
      id: @comment,
      reply_content: reply,
      format: :js
    
    assert_not_equal reply, assigns(:comment).reply
  end

  test "should not accept reply by member of different folio" do
    sign_in users(:calculus)
    reply = "Am I in the wrong folio?"

    post :reply,
      id: @comment,
      reply_content: reply,
      format: :js
    
    assert_response 403
    assert_not_equal reply, assigns(:comment).reply
  end

  test "should not accept reply by member of public" do
    reply = "Am I in the wrong folio?"

    post :reply,
      id: @comment,
      reply_content: reply,
      format: :js
    
    assert_response 401
  end
end
