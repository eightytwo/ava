require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "create with missing details" do
    user = User.new
    
    assert !user.save, "Saved a user without any details."
  end

  test "update with nil email" do
    user = users(:tintin)
    user.email = nil

    assert !user.save, "Updated a user with a nil email."
  end

  test "update with blank email" do
    user = users(:tintin)
    user.email = ""

    assert !user.save, "Updated a user with a blank email."
  end

  test "update with non-unique email" do
    user = users(:tintin)
    user.email = "haddock@marlinspikemotion.com"

    assert !user.save, "Updated a user with a non-unique email."
  end

  test "update with an invalid email" do
    user = users(:tintin)
    user.email = "abcdefg"

    assert !user.save, "Updated a user with an invalid email."
  end

  test "update with nil username" do
    user = users(:tintin)
    user.username = nil

    assert !user.save, "Updated a user with a nil username."
  end

  test "update with blank username" do
    user = users(:tintin)
    user.username = ""

    assert !user.save, "Updated a user with a blank username."
  end

  test "update with short username" do
    user = users(:tintin)
    user.username = "t"

    assert !user.save, "Updated a user with a short username."
  end

  test "update with maximum length username" do
    user = users(:tintin)
    user.username = "t" * 20

    assert user.save, "Unable to update a user with a maximum length username."
  end

  test "update with long username" do
    user = users(:tintin)
    user.username = "t" * 21

    assert !user.save, "Updated a user with a long username."
  end

  test "update with non-unique username" do
    user = users(:tintin)
    user.username = "haddock"

    assert !user.save, "Updated a user with a non-unique username."
  end  

  test "must have first name if last name supplied" do
    user = users(:calculus)
    user.first_name = nil

    assert !user.save, "Updated a user with a last name but no first name."
  end

  test "check organisations flag of member of public" do
    user = users(:jolyon)
    assert !user.organisations?, "Member of public belongs to an organisation."
  end

  test "check organisations flag of member of one organisation" do
    user = users(:tintin)
    assert(
      user.organisations?,
      "Organisation member does not belong to an organisation.")
  end

  test "check organisations flag of member of two organisations" do
    user = users(:krollspell)
    assert(
      user.organisations?,
      "Multi-organisation member does not belong to an organisation.")
  end

  test "check organisation administrator flag of organisation administrator" do
    user = users(:tintin)
    assert(
      user.organisation_admin?,
      "Organisation administrator is flagged as not an organisation administrator.")
  end

  test "check organisation administrator flag of organisation member" do
    user = users(:haddock)
    assert(
      !user.organisation_admin?,
      "Organisation member is flagged as an organisation administrator.")
  end

  test "check administered organisations of organisation administrator" do
    user = users(:tintin)
    admin_of = user.administered_organisations

    result = (admin_of.count == 1 &&
              admin_of[0].id == organisations(:marlinspike).id)

    assert(
      result,
      "List of administered organisations incorrect.")
  end

  test "check administered organisations of non-organisation administrator" do
    user = users(:sponsz)
    admin_of = user.administered_organisations

    result = (admin_of.count == 0)

    assert(
      result,
      "List of administered organisations incorrect.")
  end
end
