require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @comment = comments(:haddock_one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:comments)
  # end

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

    post :reply,
      id: @comment,
      comment: { reply_content: "Tintin's reply!" }
    
    assert_not_nil assigns(:comment)
  end

  test "should not accept reply by author of comment" do
    sign_in users(:haddock)

    post :reply,
      id: @comment,
      comment: { reply_content: "A reply to my own comment!" }
    
    assert_nil assigns(:comment)
  end
end
