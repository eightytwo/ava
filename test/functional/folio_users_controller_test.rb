require 'test_helper'

class FolioUsersControllerTest < ActionController::TestCase
  setup do
    @folio_user = folio_users(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:folio_users)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create folio_user" do
  #   assert_difference('FolioUser.count') do
  #     post :create, folio_user: {  }
  #   end

  #   assert_redirected_to folio_user_path(assigns(:folio_user))
  # end

  # test "should show folio_user" do
  #   get :show, id: @folio_user
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @folio_user
  #   assert_response :success
  # end

  # test "should update folio_user" do
  #   put :update, id: @folio_user, folio_user: {  }
  #   assert_redirected_to folio_user_path(assigns(:folio_user))
  # end

  # test "should destroy folio_user" do
  #   assert_difference('FolioUser.count', -1) do
  #     delete :destroy, id: @folio_user
  #   end

  #   assert_redirected_to folio_users_path
  # end
end
