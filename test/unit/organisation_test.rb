require 'test_helper'

class OrganisationTest < ActiveSupport::TestCase
  test "create with missing details" do
    organisation = Organisation.new
    assert !organisation.save, "Saved the organisation without any details."
  end

  test "update with nil name" do
    organisation = Organisation.find(organisations(:marlinspike).id)
    organisation.name = nil
    assert !organisation.save, "Updated an organisation with a nil name."
  end

  test "update with blank name" do
    organisation = Organisation.find(organisations(:marlinspike).id)
    organisation.name = ""
    assert !organisation.save, "Updated an organisation with a blank name."
  end
end
