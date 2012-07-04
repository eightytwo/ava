require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get new" do
    get :new
    
    assert_not_nil assigns(:message)
  end

  test "should create" do
    post :create,
      contact: {
        name: 'receiver',
        email: 'r@test.com',
        body: 'This is the email body.'
      }
    
    assert_redirected_to root_url
  end

  test "should not create when missing attribute" do
    post :create,
      contact: {
        name: 'receiver',
        email: 'r@test.com'
      }
    
    assert_not_nil assigns(:message)
  end
end
