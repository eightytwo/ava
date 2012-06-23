require 'test_helper'

class FolioTest < ActiveSupport::TestCase
  test "create with missing details" do
    folio = Folio.new
    
    assert !folio.save, "Saved a folio without any details."
  end

  test "update with nil name" do
    folio = folios(:marlinspike_one)
    folio.name = nil

    assert !folio.save, "Updated a folio with a nil name."
  end

  test "update with blank name" do
    folio = folios(:marlinspike_one)
    folio.name = ""

    assert !folio.save, "Updated a folio with a blank name."
  end

  test "update with nil description" do
    folio = folios(:marlinspike_one)
    folio.description = nil

    assert !folio.save, "Updated a folio with a nil description."
  end

  test "update with blank description" do
    folio = folios(:marlinspike_one)
    folio.description = ""
    
    assert !folio.save, "Updated a folio with a blank description."
  end

  test "update with nil organisation" do
    folio = folios(:marlinspike_one)
    folio.organisation_id = nil
    
    assert !folio.save, "Saved a folio with a nil organisation reference."
  end

  test "update with a nonexistent organisation" do
    folio = folios(:marlinspike_one)
    folio.organisation_id = 0
    
    begin
      folio.save
      assert(
        false,
        "Saved a folio with a reference to a nonexistent organisation.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end
end
