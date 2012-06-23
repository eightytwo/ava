require 'test_helper'

class OrganisationUserTest < ActiveSupport::TestCase
  test "create with missing details" do
    organisation_user = OrganisationUser.new
    
    assert !organisation_user.save, "Saved an organisation user without any details."
  end

  test "update with nil user" do
    organisation_user = organisation_users(:marlinspike_tintin)
    organisation_user.user_id = nil
    
    assert !organisation_user.save, "Saved an organisation user with a nil user reference."
  end

  test "update with a nonexistent user" do
    organisation_user = organisation_users(:marlinspike_tintin)
    organisation_user.user_id = 0
    
    begin
      organisation_user.save
      assert(
        false,
        "Saved an organisation user with a reference to a nonexistent user.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil organisation" do
    organisation_user = organisation_users(:marlinspike_tintin)
    organisation_user.organisation_id = nil
    
    assert(
      !organisation_user.save,
      "Saved an organisation user with a nil organisation reference.")
  end

  test "update with a nonexistent organisation" do
    organisation_user = organisation_users(:marlinspike_tintin)
    organisation_user.organisation_id = 0
    
    begin
      organisation_user.save
      assert(
        false,
        "Saved an organisation user with a reference to a nonexistent organisation.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "destroy all admins from organisation" do
    # Get the admins of an organisation.
    admins = OrganisationUser
      .where("organisation_id = ? and admin = true",
             organisations(:marlinspike).id)
      .all

    # Remove all administrators.
    all_destroyed = true
    admins.each { |admin| all_destroyed &&= admin.destroy }

    assert(!all_destroyed, "Removed all administrators from the organisation.")
  end

  test "change all admins to regular users in organisation" do
    # Get the admins of an organisation.
    admins = OrganisationUser
      .where("organisation_id = ? and admin = true",
             organisations(:marlinspike).id)
      .all

    # Change all administrators to regular users.
    all_changed = true
    admins.each do |admin|
      admin.admin = false
      all_changed &&= admin.save
    end

    assert(
      !all_changed,
      "Changed all administrators in the organisation to regular users.")
  end
end
