require 'test_helper'

class AudioVisualCategoryTest < ActiveSupport::TestCase
  test "create with missing details" do
    category = AudioVisualCategory.new
    assert !category.save, "Saved a category without any details."
  end

  test "update with nil organisation" do
    category = audio_visual_categories(:marlinspike_one)
    category.organisation_id = nil

    assert !category.save, "Saved a category with a nil organisation reference."
  end

  test "update with a nonexistent organisation" do
    category = audio_visual_categories(:marlinspike_one)
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
    category = audio_visual_categories(:marlinspike_one)
    category.name = nil
    
    assert !category.save, "Updated a category with a nil name."
  end

  test "update with blank name" do
    category = audio_visual_categories(:marlinspike_one)
    category.name = ""
    
    assert !category.save, "Updated a category with a blank name."
  end

  test "delete category used by round audio visual" do
    category = audio_visual_categories(:marlinspike_one)
    
    begin
      category.destroy
      assert false, "Deleted a category used by a round audio visual."
    rescue ActiveRecord::DeleteRestrictionError
      assert true
    end
  end
end
