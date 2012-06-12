require 'test_helper'

class CritiqueComponentsControllerTest < ActionController::TestCase
  setup do
    @critique_component = critique_components(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:critique_components)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create critique_component" do
    assert_difference('CritiqueComponent.count') do
      post :create, critique_component: { content: @critique_component.content, reply: @critique_component.reply, reply_created_at: @critique_component.reply_created_at, reply_updated_at: @critique_component.reply_updated_at }
    end

    assert_redirected_to critique_component_path(assigns(:critique_component))
  end

  test "should show critique_component" do
    get :show, id: @critique_component
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @critique_component
    assert_response :success
  end

  test "should update critique_component" do
    put :update, id: @critique_component, critique_component: { content: @critique_component.content, reply: @critique_component.reply, reply_created_at: @critique_component.reply_created_at, reply_updated_at: @critique_component.reply_updated_at }
    assert_redirected_to critique_component_path(assigns(:critique_component))
  end

  test "should destroy critique_component" do
    assert_difference('CritiqueComponent.count', -1) do
      delete :destroy, id: @critique_component
    end

    assert_redirected_to critique_components_path
  end
end
