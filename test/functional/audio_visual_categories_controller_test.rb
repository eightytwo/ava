require 'test_helper'

class AudioVisualCategoriesControllerTest < ActionController::TestCase
  setup do
    @audio_visual_category = audio_visual_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:audio_visual_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create audio_visual_category" do
    assert_difference('AudioVisualCategory.count') do
      post :create, audio_visual_category: { name: @audio_visual_category.name }
    end

    assert_redirected_to audio_visual_category_path(assigns(:audio_visual_category))
  end

  test "should show audio_visual_category" do
    get :show, id: @audio_visual_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @audio_visual_category
    assert_response :success
  end

  test "should update audio_visual_category" do
    put :update, id: @audio_visual_category, audio_visual_category: { name: @audio_visual_category.name }
    assert_redirected_to audio_visual_category_path(assigns(:audio_visual_category))
  end

  test "should destroy audio_visual_category" do
    assert_difference('AudioVisualCategory.count', -1) do
      delete :destroy, id: @audio_visual_category
    end

    assert_redirected_to audio_visual_categories_path
  end
end
