require 'test_helper'

class FolioUserTest < ActiveSupport::TestCase
  test "create with missing details" do
    folio_user = FolioUser.new
    
    assert !folio_user.save, "Saved a folio user without any details."
  end

  test "update with nil user" do
    folio_user = folio_users(:marlinspike_one)
    folio_user.user_id = nil
    
    assert !folio_user.save, "Saved a folio user with a nil user reference."
  end

  test "update with a nonexistent user" do
    folio_user = folio_users(:marlinspike_one)
    folio_user.user_id = 0
    
    begin
      folio_user.save
      assert(
        false,
        "Saved a folio user with a reference to a nonexistent user.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil folio" do
    folio_user = folio_users(:marlinspike_one)
    folio_user.folio_id = nil
    
    assert(
      !folio_user.save,
      "Saved a folio user with a nil folio reference.")
  end

  test "update with a nonexistent folio" do
    folio_user = folio_users(:marlinspike_one)
    folio_user.folio_id = 0
    
    begin
      folio_user.save
      assert(
        false,
        "Saved a folio user with a reference to a nonexistent folio.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil folio role" do
    folio_user = folio_users(:marlinspike_one)
    folio_user.folio_role_id = nil
    
    assert(
      !folio_user.save,
      "Saved a folio user with a nil folio role reference.")
  end

  test "update with a nonexistent folio role" do
    folio_user = folio_users(:marlinspike_one)
    folio_user.folio_role_id = 0
    
    begin
      folio_user.save
      assert(
        false,
        "Saved a folio user with a reference to a nonexistent folio role.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end
end
