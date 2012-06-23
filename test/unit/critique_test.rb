require 'test_helper'

class CritiqueTest < ActiveSupport::TestCase
  test "create with missing details" do
    critique = Critique.new
    
    assert !critique.save, "Saved a critique without any details."
  end

  test "update with nil round audio visual" do
    critique = critiques(:haddock_critique_on_tintin_av)
    critique.round_audio_visual_id = nil
    
    assert(
      !critique.save,
      "Saved a critique with a nil round audio visual reference.")
  end

  test "update with a nonexistent round audio visual" do
    critique = critiques(:haddock_critique_on_tintin_av)
    critique.round_audio_visual_id = 0
    
    begin
      critique.save
      assert(
        false,
        "Saved a critique with a reference to a nonexistent round audio visual.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil user" do
    critique = critiques(:haddock_critique_on_tintin_av)
    critique.user_id = nil
    
    assert !critique.save, "Saved a critique with a nil user reference."
  end

  test "update with a nonexistent user" do
    critique = critiques(:haddock_critique_on_tintin_av)
    critique.user_id = 0
    
    begin
      critique.save
      assert(
        false,
        "Saved a critique with a reference to a nonexistent user.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end
end
