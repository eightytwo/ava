require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  test "create with missing details" do
    round = Round.new
    
    assert !round.save, "Saved a round without any details."
  end

  test "update with nil name" do
    round = Round.find(rounds(:marlinspike_one).id)
    round.name = nil

    assert !round.save, "Updated a round with a nil name."
  end

  test "update with blank name" do
    round = Round.find(rounds(:marlinspike_one).id)
    round.name = ""

    assert !round.save, "Updated a round with a blank name."
  end

  test "update with nil folio" do
    round = Round.find(rounds(:marlinspike_one).id)
    round.folio_id = nil
    
    assert !round.save, "Saved a round with a nil folio reference."
  end

  test "update with a nonexistent folio" do
    round = Round.find(rounds(:marlinspike_one).id)
    round.folio_id = 0
    
    begin
      round.save
      assert(
        false,
        "Saved a round with a reference to a nonexistent folio.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil start date" do
    round = Round.find(rounds(:marlinspike_one).id)
    round.start_date = nil

    assert !round.save, "Updated a round with a nil start date."
  end

  test "update with blank start date" do
    round = Round.find(rounds(:marlinspike_one).id)
    round.start_date = ""

    assert !round.save, "Updated a round with a blank start date."
  end

  test "update with nil end date" do
    round = Round.find(rounds(:marlinspike_one).id)
    round.end_date = nil

    assert !round.save, "Updated a round with a nil end date."
  end

  test "update with blank end date" do
    round = Round.find(rounds(:marlinspike_one).id)
    round.end_date = ""

    assert !round.save, "Updated a round with a blank end date."
  end

  test "update with end date before start date" do
    round = Round.find(rounds(:marlinspike_one).id)
    round.start_date = "2012-05-31"
    round.end_date = "2012-05-01"

    assert !round.save, "Updated a round with an end date before the start date."
  end

  test "ensure round is closed" do
    round = Round.find(rounds(:marlinspike_one).id)
    assert !round.open?, "Round is closed."
  end

  test "ensure round is open" do
    round = Round.find(rounds(:marlinspike_two).id)
    assert round.open?, "Round is open."
  end
end
