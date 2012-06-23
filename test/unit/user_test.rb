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

  test "ensure membership summary handles bad input" do
    user = users(:tintin)
    summary = user.organisation_membership_summary(nil, nil)

    organisation_member = summary[:organisation_member]
    organisation_admin = summary[:organisation_admin]
    folio_member = summary[:folio_member]
    folio_role = summary[:folio_role]

    result_contains_data = 
      (organisation_member ||
       organisation_admin ||
       folio_member ||
       (folio_role > 0))

    assert(
      !result_contains_data,
      "Membership summary incorrectly handled bad input.")
  end

  test "ensure member of public is not organisation member" do
    user = users(:jolyon)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_one)

    summary = user.organisation_membership_summary(organisation, folio)

    assert(
      !summary[:organisation_member],
      "Member of public is member of organisation.")
  end

  test "ensure member of public is not organisation admin" do
    user = users(:jolyon)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_one)

    summary = user.organisation_membership_summary(organisation, folio)

    assert(
      !summary[:organisation_admin],
      "Member of public is administrator of organisation.")
  end

  test "ensure member of public is not folio member" do
    user = users(:jolyon)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_one)

    summary = user.organisation_membership_summary(organisation, folio)

    assert(
      !summary[:folio_member],
      "Member of public is member of folio.")
  end

  test "ensure member of public has no folio role" do
    user = users(:jolyon)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_one)

    summary = user.organisation_membership_summary(organisation, folio)

    assert_equal(
      summary[:folio_role],
      0,
      "Member of public has a role in the folio.")
  end

  test "ensure organisation administrator is organisation member" do
    user = users(:nestor)
    organisation = organisations(:marlinspike)

    summary = user.organisation_membership_summary(organisation, nil)

    assert(
      summary[:organisation_member],
      "Organisation administrator is not a member of the organisation.")
  end

    test "ensure organisation administrator is organisation administrator" do
    user = users(:nestor)
    organisation = organisations(:marlinspike)

    summary = user.organisation_membership_summary(organisation, nil)

    assert(
      summary[:organisation_admin],
      "Organisation administrator is not an administrator of the organisation.")
  end

  test "ensure organisation administrator is not folio member" do
    user = users(:nestor)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_one)

    summary = user.organisation_membership_summary(organisation, folio)

    assert(
      !summary[:folio_member],
      "Organisation administrator is a folio member.")
  end

  test "ensure organisation administrator has no folio role" do
    user = users(:nestor)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_one)

    summary = user.organisation_membership_summary(organisation, folio)

    assert_equal(
      summary[:folio_role],
      0,
      "Organisation administrator has a folio role.")
  end

  test "ensure folio administrator is not organisation administrator" do
    user = users(:calculus)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_two)

    summary = user.organisation_membership_summary(organisation, folio)

    assert(
      !summary[:organisation_admin],
      "Folio administrator is an organisation administrator.")
  end

  test "ensure folio administrator is a folio administrator" do
    user = users(:calculus)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_two)
    folio_role_admin = FolioRole.where(name: 'Administrator').first

    summary = user.organisation_membership_summary(organisation, folio)

    assert_equal(
      summary[:folio_role],
      folio_role_admin.id,
      "Folio administrator is not a folio administrator.")
  end

  test "ensure organisation membership is correct" do
    user = users(:rastapopoulos)
    organisation = organisations(:marlinspike)
    
    summary = user.organisation_membership_summary(organisation, nil)

    assert(
      !summary[:organisation_member],
      "Organisation member reported as belonging to wrong organisation.")
  end

  test "ensure organisation administration is correct" do
    user = users(:rastapopoulos)
    organisation = organisations(:marlinspike)
    
    summary = user.organisation_membership_summary(organisation, nil)

    assert(
      !summary[:organisation_admin],
      "Organisation member reported as administering wrong organisation.")
  end

  test "ensure folio membership is correct" do
    user = users(:calculus)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_one)
    
    summary = user.organisation_membership_summary(organisation, folio)

    assert(
      !summary[:folio_member],
      "User reported as member of wrong folio.")
  end

  test "ensure folio role is correct" do
    user = users(:calculus)
    organisation = organisations(:marlinspike)
    folio = folios(:marlinspike_one)
    
    summary = user.organisation_membership_summary(organisation, folio)

    assert_equal(
      summary[:folio_role],
      0,
      "User reported as having folio role in wrong folio.")
  end

  test "ensure membership in two organisations" do
    user = users(:krollspell)
    marlinspike = organisations(:marlinspike)
    cosmos = organisations(:cosmos)
    
    marlinspike_summary = user.organisation_membership_summary(marlinspike, nil)
    cosmos_summary = user.organisation_membership_summary(cosmos, nil)

    assert(
      (marlinspike_summary[:organisation_member] and
       cosmos_summary[:organisation_member]),
      "User not reported as a member of two organisations.")
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
