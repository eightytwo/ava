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

  test "organisation admin not in folio can see comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:nestor)

    assert(
      rav.comments_visible_to?(user),
      "Organisation admin unable to see round audio visual.")
  end

  test "folio admin can see comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:tintin)

    assert(
      rav.comments_visible_to?(user),
      "Folio admin unable to see round audio visual.")
  end

  test "folio contributor can see comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:haddock)

    assert(
      rav.comments_visible_to?(user),
      "Folio contributor unable to see round audio visual.")
  end

  test "folio viewer can see comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:snowy)

    assert(
      rav.comments_visible_to?(user),
      "Foio viewer unable to see round audio visual.")
  end

  test "member of other folio in organisation cannot see comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:calculus)

    assert(
      !rav.comments_visible_to?(user),
      "Other folio member can see round audio visual.")
  end

  test "member of other organisation cannot see comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:rastapopoulos)

    assert(
      !rav.comments_visible_to?(user),
      "Other organisation member can see round audio visual.")
  end

  test "member of public cannot see comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:jolyon)

    assert(
      !rav.comments_visible_to?(user),
      "Member of public can see round audio visual.")
  end

  test "organisation admin not in folio can not add comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:nestor)

    assert(
      !rav.accepts_comments_from?(user),
      "Organisation admin can add comments to round audio visual.")
  end

  test "folio admin can add comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:tintin)

    assert(
      rav.accepts_comments_from?(user),
      "Folio admin unable to add comments to round audio visual.")
  end

  test "folio contributor can add comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:haddock)

    assert(
      rav.accepts_comments_from?(user),
      "Folio contributor unable to add comments to round audio visual.")
  end

  test "folio viewer can add comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:snowy)

    assert(
      rav.accepts_comments_from?(user),
      "Foio viewer unable to add comments to round audio visual.")
  end

  test "member of other folio in organisation cannot add comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:calculus)

    assert(
      !rav.accepts_comments_from?(user),
      "Other folio member can add comments to round audio visual.")
  end

  test "member of other organisation cannot add comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:rastapopoulos)

    assert(
      !rav.accepts_comments_from?(user),
      "Other organisation member can add comments to round audio visual.")
  end

  test "member of public cannot add comments" do
    rav = round_audio_visuals(:marlinkspike_f1_r1_av_one)

    user = users(:jolyon)

    assert(
      !rav.accepts_comments_from?(user),
      "Member of public can add comments to round audio visual.")
  end
end
