require "test_helper"

class FeedbackTest < ActiveSupport::TestCase
  test "valid feedback saves with default category" do
    feedback = Feedback.new(title: "Slow export", description: "Export takes too long.")

    assert feedback.valid?
    assert feedback.save
    assert_equal "other", feedback.category
  end

  test "blank title is invalid" do
    feedback = Feedback.new(title: "", description: "Details")

    assert_not feedback.valid?
    assert_includes feedback.errors[:title], "can't be blank"
  end

  test "blank description is invalid" do
    feedback = Feedback.new(title: "Title", description: "")

    assert_not feedback.valid?
    assert_includes feedback.errors[:description], "can't be blank"
  end
end
