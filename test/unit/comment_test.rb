require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "create with missing details" do
    comment = Comment.new
    
    assert !comment.save, "Saved a comment without any details."
  end

  test "update with nil user" do
    comment = comments(:haddock_one)
    comment.user_id = nil
    
    assert !comment.save, "Saved a comment with a nil user reference."
  end

  test "update with a nonexistent organisation" do
    comment = comments(:haddock_one)
    comment.user_id = 0
    
    begin
      comment.save
      assert(
        false,
        "Saved a comment with a reference to a nonexistent user.")
    rescue ActiveRecord::InvalidForeignKey
      assert true
    rescue Exception => e
      assert false, e.message
    end
  end

  test "update with nil content" do
    comment = comments(:haddock_one)
    comment.content = nil

    assert !comment.save, "Updated a comment with nil content."
  end

  test "update with blank content" do
    comment = comments(:haddock_one)
    comment.content = ""

    assert !comment.save, "Updated a comment with blank content."
  end
end
