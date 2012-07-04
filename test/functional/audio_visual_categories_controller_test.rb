require 'test_helper'

class AudioVisualCategoriesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @audio_visual_category = audio_visual_categories(:marlinspike_one)
    @audio_visual_category_two = audio_visual_categories(:marlinspike_two)
  end

  #
  # :index tests
  #

  test "should get index as admin of organisation" do
    sign_in users(:tintin)
    get :index, oid: organisations(:marlinspike)    
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should not get index as admin of different organisation" do
    sign_in users(:rastapopoulos)
    get :index, oid: organisations(:marlinspike)   
    assert_response 403
  end

  test "should not get index as member of organisation" do
    sign_in users(:haddock)
    get :index, oid: organisations(:marlinspike)
    assert_response 403
  end

  test "should not get index as member of public" do
    get :index, oid: organisations(:marlinspike)
    assert_redirected_to new_user_session_path
  end


  #
  # :new tests
  #

  test "should get new as admin of organisation" do
    sign_in users(:tintin)
    get :new, oid: organisations(:marlinspike)
    assert_response :success
  end

  test "should not get new as admin of different organisation" do
    sign_in users(:rastapopoulos)
    get :new, oid: organisations(:marlinspike)
    assert_response 403
  end

  test "should not get new as member of organisation" do
    sign_in users(:haddock)
    get :new, oid: organisations(:marlinspike)
    assert_response 403
  end

  test "should not get new as member of public" do
    get :new, oid: organisations(:marlinspike)
    assert_redirected_to new_user_session_path
  end


  #
  # :create tests
  #

  test "should create audio_visual_category" do
    sign_in users(:tintin)
    assert_difference('AudioVisualCategory.count') do
      post :create, audio_visual_category: {
        name: @audio_visual_category.name,
        organisation_id: organisations(:marlinspike)
      }
    end

    assert_redirected_to(
      audio_visual_categories_path oid: organisations(:marlinspike))
  end

  test "should not create audio_visual_category (not organisation admin)" do
    sign_in users(:haddock)

    assert_no_difference('AudioVisualCategory.count') do
      post :create, audio_visual_category: {
        name: @audio_visual_category.name,
        organisation_id: organisations(:marlinspike)
      }
    end

    assert_response 403
  end

  test "should not create audio_visual_category (different organisation)" do
    sign_in users(:rastapopoulos)

    assert_no_difference('AudioVisualCategory.count') do
      post :create, audio_visual_category: {
        name: @audio_visual_category.name,
        organisation_id: organisations(:marlinspike)
      }
    end

    assert_response 403
  end

  test "should not create audio_visual_category (public)" do
    assert_no_difference('AudioVisualCategory.count') do
      post :create, audio_visual_category: {
        name: @audio_visual_category.name,
        organisation_id: organisations(:marlinspike)
      }
    end

    assert_redirected_to new_user_session_path
  end


  #
  # :edit tests
  #
  
  test "should get edit as admin of organisation" do
    sign_in users(:tintin)
    get :edit, id: @audio_visual_category
    assert_response :success
  end

  test "should not get edit as admin of different organisation" do
    sign_in users(:rastapopoulos)
    get :edit, id: @audio_visual_category
    assert_response 403
  end

  test "should not get edit as member of organisation" do
    sign_in users(:haddock)
    get :edit, id: @audio_visual_category
    assert_response 403
  end

  test "should not get edit as member of public" do
    get :edit, id: @audio_visual_category
    assert_redirected_to new_user_session_path
  end


  #
  # :update tests
  #

  test "should update audio_visual_category as admin of organisation" do
    sign_in users(:tintin)
    new_name = "The new category"

    put(
      :update,
      id: @audio_visual_category,
      audio_visual_category: {
        name: new_name
      })
    
    assert_equal(
      new_name,
      AudioVisualCategory.find(@audio_visual_category).name)

    assert_redirected_to(
      audio_visual_categories_path(oid: organisations(:marlinspike)))
  end

  test "should not update audio_visual_category as admin of different organisation" do
    sign_in users(:rastapopoulos)
    new_name = "The new category"

    put(
      :update,
      id: @audio_visual_category,
      audio_visual_category: {
        name: new_name
      })
    
    assert_response 403
    assert_not_equal(
      new_name,
      AudioVisualCategory.find(@audio_visual_category).name)
  end

  test "should not update audio_visual_category as member of organisation" do
    sign_in users(:haddock)
    new_name = "The new category"
    
    put(
      :update,
      id: @audio_visual_category,
      audio_visual_category: {
        name: new_name
      })
    
    assert_response 403
    assert_not_equal(
      new_name,
      AudioVisualCategory.find(@audio_visual_category).name)
  end

  test "should not update audio_visual_category as member of public" do
    new_name = "The new category"

    put(
      :update,
      id: @audio_visual_category,
      audio_visual_category: {
        name: new_name
      })
    
    assert_not_equal(
      new_name,
      AudioVisualCategory.find(@audio_visual_category).name)
    
    assert_redirected_to new_user_session_path
  end


  #
  # :destroy tests
  #

  test "should destroy audio_visual_category as admin of organisation" do
    sign_in users(:tintin)
    
    assert_difference('AudioVisualCategory.count', -1) do
      delete :destroy, id: @audio_visual_category_two
    end

    assert_redirected_to(
      audio_visual_categories_path(oid: organisations(:marlinspike)))
  end

  test "should not destroy audio_visual_category used by round audio visual" do
    sign_in users(:tintin)
    
    assert_no_difference('AudioVisualCategory.count') do
      delete :destroy, id: @audio_visual_category
    end

    assert_redirected_to(
      audio_visual_categories_path(oid: organisations(:marlinspike)))
  end

  test "should not destroy audio_visual_category as admin of different organisation" do
    sign_in users(:rastapopoulos)
    
    assert_no_difference('AudioVisualCategory.count', -1) do
      delete :destroy, id: @audio_visual_category_two
    end

    assert_response 403
  end

  test "should not destroy audio_visual_category as member of organisation" do
    sign_in users(:haddock)
    
    assert_no_difference('AudioVisualCategory.count', -1) do
      delete :destroy, id: @audio_visual_category_two
    end

    assert_response 403
  end

  test "should not destroy audio_visual_category as member of public" do   
    assert_no_difference('AudioVisualCategory.count', -1) do
      delete :destroy, id: @audio_visual_category_two
    end

    assert_redirected_to new_user_session_path
  end
end
