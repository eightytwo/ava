require 'test_helper'

class AudioVisualTest < ActiveSupport::TestCase
  test "create with missing details" do
    audio_visual = AudioVisual.new
    
    assert !audio_visual.save, "Saved an audio visual without any details."
  end

  test "update with nil user" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.user_id = nil

    assert(
      !audio_visual.save,
      "Updated an audio visual with a nil user reference.")
  end

  test "update with nonexistent user" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.user_id = 0

    begin
      !audio_visual.save
      assert(
        false,
        "Updated an audio visual with a reference to a nonexistent user.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil title" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.title = nil

    assert !audio_visual.save, "Updated an audio visual with a nil title."
  end

  test "update with blank title" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.title = ""

    assert !audio_visual.save, "Updated an audio visual with a blank title."
  end

  test "update with nil description" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.description = nil

    assert(
      !audio_visual.save,
      "Updated an audio visual with a nil description.")
  end

  test "update with blank description" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.description = ""

    assert(
      !audio_visual.save,
      "Updated an audio visual with a blank description.")
  end

  test "update with nil music" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.music = nil

    assert(
      !audio_visual.save,
      "Updated an audio visual with a nil music.")
  end

  test "update with blank music" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.music = ""

    assert(
      !audio_visual.save,
      "Updated an audio visual with a blank music.")
  end

  test "update with nil location" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.location = nil

    assert(
      !audio_visual.save,
      "Updated an audio visual with a nil location.")
  end

  test "update with blank location" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.location = ""

    assert(
      !audio_visual.save,
      "Updated an audio visual with a blank location.")
  end

  test "update with nil production notes" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.production_notes = nil

    assert(
      !audio_visual.save,
      "Updated an audio visual with a nil production notes.")
  end

  test "update with blank production notes" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.production_notes = ""

    assert(
      !audio_visual.save,
      "Updated an audio visual with a blank production notes.")
  end

  test "update with nil tags" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.tags = nil

    assert(
      !audio_visual.save,
      "Updated an audio visual with a nil tags.")
  end

  test "update with blank tags" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.tags = ""

    assert(
      !audio_visual.save,
      "Updated an audio visual with a blank tags.")
  end

  test "verify public commenting" do
    audio_visual = audio_visuals(:tintin_one)
    audio_visual.public = false
    audio_visual.allow_commenting = true

    audio_visual.save

    audio_visual = audio_visuals(:tintin_one)

    assert(
      !audio_visual.allow_commenting,
      "Audio visual is not public but allows commenting.")
  end
end
