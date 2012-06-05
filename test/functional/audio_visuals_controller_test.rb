require 'test_helper'

class AudioVisualsControllerTest < ActionController::TestCase
  setup do
    @audio_visual = audio_visuals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:audio_visuals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create audio_visual" do
    assert_difference('AudioVisual.count') do
      post :create, audio_visual: { description: @audio_visual.description, external_reference: @audio_visual.external_reference, length: @audio_visual.length, location: @audio_visual.location, music: @audio_visual.music, production_notes: @audio_visual.production_notes, rating: @audio_visual.rating, tags: @audio_visual.tags, title: @audio_visual.title, views: @audio_visual.views }
    end

    assert_redirected_to audio_visual_path(assigns(:audio_visual))
  end

  test "should show audio_visual" do
    get :show, id: @audio_visual
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @audio_visual
    assert_response :success
  end

  test "should update audio_visual" do
    put :update, id: @audio_visual, audio_visual: { description: @audio_visual.description, external_reference: @audio_visual.external_reference, length: @audio_visual.length, location: @audio_visual.location, music: @audio_visual.music, production_notes: @audio_visual.production_notes, rating: @audio_visual.rating, tags: @audio_visual.tags, title: @audio_visual.title, views: @audio_visual.views }
    assert_redirected_to audio_visual_path(assigns(:audio_visual))
  end

  test "should destroy audio_visual" do
    assert_difference('AudioVisual.count', -1) do
      delete :destroy, id: @audio_visual
    end

    assert_redirected_to audio_visuals_path
  end
end
