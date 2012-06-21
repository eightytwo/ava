require 'test_helper'

class RoundAudioVisualsControllerTest < ActionController::TestCase
  setup do
    @round_audio_visual = round_audio_visuals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:round_audio_visuals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create round_audio_visual" do
    assert_difference('RoundAudioVisual.count') do
      post :create, round_audio_visual: { allow_commenting: @round_audio_visual.allow_commenting, allow_critiquing: @round_audio_visual.allow_critiquing }
    end

    assert_redirected_to round_audio_visual_path(assigns(:round_audio_visual))
  end

  test "should show round_audio_visual" do
    get :show, id: @round_audio_visual
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @round_audio_visual
    assert_response :success
  end

  test "should update round_audio_visual" do
    put :update, id: @round_audio_visual, round_audio_visual: { allow_commenting: @round_audio_visual.allow_commenting, allow_critiquing: @round_audio_visual.allow_critiquing }
    assert_redirected_to round_audio_visual_path(assigns(:round_audio_visual))
  end

  test "should destroy round_audio_visual" do
    assert_difference('RoundAudioVisual.count', -1) do
      delete :destroy, id: @round_audio_visual
    end

    assert_redirected_to round_audio_visuals_path
  end
end
