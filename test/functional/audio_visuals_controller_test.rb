require 'test_helper'

class AudioVisualsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @audio_visual = audio_visuals(:tintin_one)
    @public_audio_visual = audio_visuals(:public_one)
  end

  #
  # :new tests
  #

  test "should get new as member of site" do
    sign_in users(:jolyon)
    get :new    
    assert_response :success
  end

  test "should not get new as member of public" do
    get :new
    assert_redirected_to new_user_session_path
  end


  #
  # :create tests
  #

  test "should create audio_visual as member of site" do
    sign_in users(:jolyon)

    assert_difference('AudioVisual.count') do
      post(
        :create,
        audio_visual: {
          user_id: @audio_visual.user,
          description: @audio_visual.description,
          external_reference: @audio_visual.external_reference,
          location: @audio_visual.location,
          music: @audio_visual.music,
          production_notes: @audio_visual.production_notes,
          tags: @audio_visual.tags,
          title: @audio_visual.title
      })
    end

    assert_redirected_to audio_visual_path(assigns(:audio_visual))
  end

  test "should not create audio_visual as member of public" do   
    assert_no_difference('AudioVisual.count') do
      post(
        :create,
        audio_visual: {
          user_id: @audio_visual.user,
          description: @audio_visual.description,
          external_reference: @audio_visual.external_reference,
          location: @audio_visual.location,
          music: @audio_visual.music,
          production_notes: @audio_visual.production_notes,
          tags: @audio_visual.tags,
          title: @audio_visual.title
      })
    end

    assert_redirected_to new_user_session_path
  end


  #
  # :show tests
  #

  # test "should show public audio_visual as member of public" do
  #   get :show, id: @public_audio_visual
  #   assert_response :success
  # end

  test "should show private audio_visual as audio visual owner" do
    sign_in users(:tintin)
    get :show, id: @audio_visual
    assert_response :success
  end

  test "should show private audio_visual as site administrator" do
    sign_in users(:admin)
    get :show, id: @audio_visual
    assert_response :success
  end

  # test "should not show private audio_visual as member of public" do
  #   get :show, id: @audio_visual
  #   assert_redirected_to new_user_session_path
  # end

  test "should not show private audio_visual as member of site" do
    sign_in users(:haddock)
    get :show, id: @audio_visual
    assert_response 403
  end


  #
  # :edit tests
  #

  test "should get edit of private audio visual as audio visual owner" do
    sign_in users(:tintin)
    get :edit, id: @audio_visual
    assert_response :success
  end

  test "should get edit of private audio visual as site administrator" do
    sign_in users(:admin)
    get :edit, id: @audio_visual
    assert_response :success
  end

  test "should not get edit of private audio visual as member of public" do
    get :edit, id: @audio_visual
    assert_redirected_to new_user_session_path
  end

  test "should not get edit of private audio visual as member of site" do
    sign_in users(:haddock)
    get :edit, id: @audio_visual
    assert_response 403
  end

  test "should get edit of public audio visual as audio visual owner" do
    sign_in users(:jolyon)
    get :edit, id: @public_audio_visual
    assert_response :success
  end

  test "should get edit of public audio visual as site administrator" do
    sign_in users(:admin)
    get :edit, id: @public_audio_visual
    assert_response :success
  end

  test "should not get edit of public audio visual as member of public" do
    get :edit, id: @public_audio_visual
    assert_redirected_to new_user_session_path
  end

  test "should not get edit of public audio visual as member of site" do
    sign_in users(:haddock)
    get :edit, id: @public_audio_visual
    assert_response 403
  end


  #
  # :update tests
  #

  test "should update audio_visual as owner of audio visual" do
    sign_in users(:tintin)
    put(
      :update,
      id: @audio_visual,
      audio_visual: {
        description: @audio_visual.description,
        external_reference: @audio_visual.external_reference,
        location: @audio_visual.location,
        music: @audio_visual.music,
        production_notes: @audio_visual.production_notes,
        tags: @audio_visual.tags,
        title: @audio_visual.title,
      })
    assert_redirected_to audio_visual_path(assigns(:audio_visual))
  end

  test "should update audio_visual as administrator of site" do
    sign_in users(:admin)
    put(
      :update,
      id: @audio_visual,
      audio_visual: {
        description: @audio_visual.description,
        external_reference: @audio_visual.external_reference,
        location: @audio_visual.location,
        music: @audio_visual.music,
        production_notes: @audio_visual.production_notes,
        tags: @audio_visual.tags,
        title: @audio_visual.title,
      })
    assert_redirected_to audio_visual_path(assigns(:audio_visual))
  end

  test "should not update audio_visual as member of site" do
    sign_in users(:haddock)
    put(
      :update,
      id: @audio_visual,
      audio_visual: {
        description: @audio_visual.description,
        external_reference: @audio_visual.external_reference,
        location: @audio_visual.location,
        music: @audio_visual.music,
        production_notes: @audio_visual.production_notes,
        tags: @audio_visual.tags,
        title: @audio_visual.title,
      })
    assert_response 403
  end

  test "should not update audio_visual as member of public" do
    put(
      :update,
      id: @audio_visual,
      audio_visual: {
        description: @audio_visual.description,
        external_reference: @audio_visual.external_reference,
        location: @audio_visual.location,
        music: @audio_visual.music,
        production_notes: @audio_visual.production_notes,
        tags: @audio_visual.tags,
        title: @audio_visual.title,
      })
    assert_redirected_to new_user_session_path
  end


  #
  # :destroy tests
  #

  test "should destroy audio_visual as owner" do
    sign_in users(:tintin)
    
    assert_difference('AudioVisual.count', -1) do
      delete :destroy, id: @audio_visual
    end

    assert_redirected_to root_url
  end

  test "should destroy audio_visual as site admin" do
    sign_in users(:admin)
    
    assert_difference('AudioVisual.count', -1) do
      delete :destroy, id: @audio_visual
    end

    assert_redirected_to root_url
  end

  test "should not destroy audio_visual as member of site" do
    sign_in users(:haddock)
    
    assert_no_difference('AudioVisual.count') do
      delete :destroy, id: @audio_visual
    end

    assert_response 403
  end

  test "should not destroy audio_visual as member of public" do
    assert_no_difference('AudioVisual.count') do
      delete :destroy, id: @audio_visual
    end

    assert_redirected_to new_user_session_path
  end
end
