require 'test_helper'

class RoundAudioVisualTest < ActiveSupport::TestCase
  test "create with missing details" do
    rav = RoundAudioVisual.new
    
    assert !rav.save, "Saved a round audio visual without any details."
  end

  test "update with nil round" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)
    rav.round_id = nil
    
    assert !rav.save, "Saved a round audio visual with a nil round reference."
  end

  test "update with a nonexistent round" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)
    rav.round_id = 0
    
    begin
      rav.save
      assert(
        false,
        "Saved a round audio visual with a reference to a nonexistent round.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil audio visual" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)
    rav.audio_visual = nil
    
    assert(
      !rav.save,
      "Saved a round audio visual with a nil audio visual.")
  end

  test "update with nil audio visual category" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)
    rav.audio_visual_category_id = nil
    
    assert(
      !rav.save,
      "Saved a round audio visual with a nil audio visual category reference.")
  end

  test "update with a nonexistent audio visual category" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)
    rav.audio_visual_category_id = 0
    
    begin
      rav.save
      assert(
        false,
        "Saved a round audio visual with a reference to a nonexistent audio visual category.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end
end
