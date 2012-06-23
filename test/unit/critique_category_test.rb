require 'test_helper'

class CritiqueCategoryTest < ActiveSupport::TestCase
  test "create with missing details" do
    category = CritiqueCategory.new
    assert !category.save, "Saved a category without any details."
  end

  test "update with nil organisation" do
    category = CritiqueCategory.find(
      critique_categories(:marlinspike_audio).id)
    category.organisation_id = nil
    
    assert !category.save, "Saved a category with a nil organisation reference."
  end

  test "update with a nonexistent organisation" do
    category = CritiqueCategory.find(
      critique_categories(:marlinspike_audio).id)
    category.organisation_id = 0
    
    begin
      category.save
      assert(
        false,
        "Saved a category with a reference to a nonexistent organisation.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil name" do
    category = CritiqueCategory.find(
      critique_categories(:marlinspike_audio).id)
    category.name = nil
    
    assert !category.save, "Updated a category with a nil name."
  end

  test "update with blank name" do
    category = CritiqueCategory.find(
      critique_categories(:marlinspike_audio).id)
    category.name = ""
    
    assert !category.save, "Updated a category with a blank name."
  end

  test "delete category used by critique" do
    category = CritiqueCategory.find(
      critique_categories(:marlinspike_audio).id)
    
    begin
      category.destroy
      assert false, "Deleted a category used by a round audio visual."
    rescue ActiveRecord::DeleteRestrictionError
      assert true
    end
  end
end
