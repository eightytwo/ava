require 'test_helper'

class FolioRoleTest < ActiveSupport::TestCase
  test "create with missing details" do
    folio_role = FolioRole.new
    
    assert !folio_role.save, "Saved a folio role without any details."
  end

  test "update with nil name" do
    folio_role = FolioRole.find(folio_roles(:viewer).id)
    folio_role.name = nil

    assert !folio_role.save, "Updated a folio role with a nil name."
  end

  test "update with blank name" do
    folio_role = FolioRole.find(folio_roles(:viewer).id)
    folio_role.name = ""

    assert !folio_role.save, "Updated a folio role with a blank name."
  end

  test "update with nil description" do
    folio_role = FolioRole.find(folio_roles(:viewer).id)
    folio_role.description = nil

    assert !folio_role.save, "Updated a folio role with a nil description."
  end

  test "update with blank description" do
    folio_role = FolioRole.find(folio_roles(:viewer).id)
    folio_role.description = ""

    assert !folio_role.save, "Updated a folio role with a blank description."
  end
end
