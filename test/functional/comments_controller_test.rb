require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @comment = comments(:haddock_one)
  end

  test "should get index as folio viewer" do
    sign_in users(:snowy)
    get :index, id: @comment
    assert_not_nil assigns(:comments)
  end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create comment" do
  #   assert_difference('Comment.count') do
  #     post :create, comment: { content: @comment.content }
  #   end

  #   assert_redirected_to comment_path(assigns(:comment))
  # end

  # test "should show comment" do
  #   get :show, id: @comment
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @comment
  #   assert_response :success
  # end

  # test "should update comment" do
  #   put :update, id: @comment, comment: { content: @comment.content }
  #   assert_redirected_to comment_path(assigns(:comment))
  # end

  # test "should destroy comment" do
  #   assert_difference('Comment.count', -1) do
  #     delete :destroy, id: @comment
  #   end

  #   assert_redirected_to comments_path
  # end

  test "should accept reply by owner of commentable" do
    sign_in users(:tintin)
    reply = "Tintin's Reply!"

    post :reply,
      id: @comment,
      reply_content: reply

    assert_not_nil assigns(:comment)
    assert_equal reply, Comment.find(@comment).reply
  end

  test "should not accept reply by author of comment" do
    sign_in users(:haddock)
    reply = "A reply to my own comment!"

    post :reply,
      id: @comment,
      reply_content: reply
    
    assert_not_nil assigns(:comment)
    assert_not_equal reply, assigns(:comment).reply
  end
end
