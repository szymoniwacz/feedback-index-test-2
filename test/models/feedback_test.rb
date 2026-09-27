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

  test "invalid category is rejected" do
    feedback = Feedback.new(title: "Title", description: "Body", category: "spam")

    assert_not feedback.valid?
    assert_includes feedback.errors[:category], "is not included in the list"
  end

  test "ordered_for_inbox sorts newest first with id tie-break" do
    Feedback.delete_all
    timestamp = Time.zone.parse("2026-09-27 12:00:00")
    first = Feedback.create!(title: "A", description: "First", created_at: timestamp, updated_at: timestamp)
    second = Feedback.create!(title: "B", description: "Second", created_at: timestamp, updated_at: timestamp)

    assert_equal [second, first], Feedback.ordered_for_inbox.to_a
  end
end
