require 'test_helper'

class OrganisationUsersControllerTest < ActionController::TestCase
  setup do
    @organisation_user = organisation_users(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:organisation_users)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create organisation_user" do
  #   assert_difference('OrganisationUser.count') do
  #     post :create, organisation_user: {  }
  #   end

  #   assert_redirected_to organisation_user_path(assigns(:organisation_user))
  # end

  # test "should show organisation_user" do
  #   get :show, id: @organisation_user
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @organisation_user
  #   assert_response :success
  # end

  # test "should update organisation_user" do
  #   put :update, id: @organisation_user, organisation_user: {  }
  #   assert_redirected_to organisation_user_path(assigns(:organisation_user))
  # end

  # test "should destroy organisation_user" do
  #   assert_difference('OrganisationUser.count', -1) do
  #     delete :destroy, id: @organisation_user
  #   end

  #   assert_redirected_to organisation_users_path
  # end
end
