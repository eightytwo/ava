require 'test_helper'

class CritiquesControllerTest < ActionController::TestCase
  setup do
    @critique = critiques(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:critiques)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create critique" do
    assert_difference('Critique.count') do
      post :create, critique: {  }
    end

    assert_redirected_to critique_path(assigns(:critique))
  end

  test "should show critique" do
    get :show, id: @critique
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @critique
    assert_response :success
  end

  test "should update critique" do
    put :update, id: @critique, critique: {  }
    assert_redirected_to critique_path(assigns(:critique))
  end

  test "should destroy critique" do
    assert_difference('Critique.count', -1) do
      delete :destroy, id: @critique
    end

    assert_redirected_to critiques_path
  end
end
