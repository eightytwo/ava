require 'test_helper'

class CritiqueCategoriesControllerTest < ActionController::TestCase
  setup do
    @critique_category = critique_categories(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:critique_categories)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create critique_category" do
  #   assert_difference('CritiqueCategory.count') do
  #     post :create, critique_category: { lft: @critique_category.lft, name: @critique_category.name, parent_id: @critique_category.parent_id, rgt: @critique_category.rgt }
  #   end

  #   assert_redirected_to critique_category_path(assigns(:critique_category))
  # end

  # test "should show critique_category" do
  #   get :show, id: @critique_category
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @critique_category
  #   assert_response :success
  # end

  # test "should update critique_category" do
  #   put :update, id: @critique_category, critique_category: { lft: @critique_category.lft, name: @critique_category.name, parent_id: @critique_category.parent_id, rgt: @critique_category.rgt }
  #   assert_redirected_to critique_category_path(assigns(:critique_category))
  # end

  # test "should destroy critique_category" do
  #   assert_difference('CritiqueCategory.count', -1) do
  #     delete :destroy, id: @critique_category
  #   end

  #   assert_redirected_to critique_categories_path
  # end
end
