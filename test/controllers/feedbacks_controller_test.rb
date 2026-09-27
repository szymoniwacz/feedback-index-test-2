require "test_helper"

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  test "create with valid params persists feedback and redirects" do
    before_count = Feedback.count
    post feedbacks_path, params: {
      feedback: { title: "Keyboard shortcut", description: "Add save shortcut." }
    }
    assert_equal before_count + 1, Feedback.count

    feedback = Feedback.order(:id).last
    assert_redirected_to feedback_path(feedback)
    follow_redirect!
    assert_match "Keyboard shortcut", response.body
  end

  test "create with blank fields re-renders form with errors and preserved input" do
    assert_no_difference "Feedback.count" do
      post feedbacks_path, params: {
        feedback: { title: "", description: "Kept description" }
      }
    end

    assert_response :unprocessable_entity
    assert_select "input[name='feedback[title]'][value=?]", ""
    assert_select "textarea[name='feedback[description]']", text: /Kept description/
    assert_select "#error_explanation"
  end

  test "new form is accessible" do
    get new_feedback_path

    assert_response :success
    assert_select "form[action=?]", feedbacks_path
    assert_select "label", text: "Title"
    assert_select "label", text: "Description"
  end

  test "update category persists change" do
    feedback = Feedback.create!(title: "Export bug", description: "Fails on large files.")

    patch feedback_path(feedback), params: { feedback: { category: "bug" } }

    assert_redirected_to feedback_path(feedback)
    assert_equal "bug", feedback.reload.category
  end

  test "update with invalid category re-renders show with errors" do
    feedback = Feedback.create!(title: "Idea", description: "Nice to have.")

    patch feedback_path(feedback, category: "bug"), params: { feedback: { category: "invalid" } }

    assert_response :unprocessable_entity
    assert_equal "other", feedback.reload.category
    assert_select "#category_error_explanation"
    assert_select "a[href=?]", root_path(category: "bug"), text: "Back to inbox"

    get new_feedback_path
    assert_response :success
    assert_select "form[action=?][method=post]", feedbacks_path
  end

  test "show for missing feedback returns not found without affecting other items" do
    existing = Feedback.create!(title: "Still here", description: "Unchanged.")

    get feedback_path(9_999_999)

    assert_response :not_found
    assert_match "does not exist", response.body
    assert_equal "Still here", existing.reload.title
  end

  test "update for missing feedback returns not found without affecting other items" do
    existing = Feedback.create!(title: "Still here", description: "Unchanged.")

    patch feedback_path(9_999_999), params: { feedback: { category: "bug" } }

    assert_response :not_found
    assert_equal "other", existing.reload.category
  end

  test "show category form has unique labelled controls" do
    first = Feedback.create!(title: "One", description: "First item.")
    second = Feedback.create!(title: "Two", description: "Second item.")

    get feedback_path(first)
    assert_response :success
    assert_select "label[for=?]", "feedback_#{first.id}_category_bug"
    assert_select "input#feedback_#{first.id}_category_bug[type=radio]"

    get feedback_path(second)
    assert_select "label[for=?]", "feedback_#{second.id}_category_bug"
    assert_select "input#feedback_#{second.id}_category_bug[type=radio]"
  end

  test "index filter shows only matching category" do
    Feedback.delete_all
    bug = Feedback.create!(title: "Crash", description: "App exits.", category: "bug")
    Feedback.create!(title: "Idea", description: "Dark mode.", category: "feature request")

    get root_path, params: { category: "bug" }

    assert_response :success
    assert_select "article h2", count: 1
    assert_select "article h2 a", text: bug.title
    assert_select "input#filter_category_bug[checked]"
  end

  test "index filter all shows every item" do
    Feedback.delete_all
    Feedback.create!(title: "One", description: "First.", category: "bug")
    Feedback.create!(title: "Two", description: "Second.", category: "other")

    get root_path, params: { category: "all" }

    assert_response :success
    assert_select "article h2", count: 2
    assert_select "input#filter_category_all[checked]"
  end

  test "index filter with no matches shows category empty state" do
    Feedback.delete_all
    Feedback.create!(title: "Only bug", description: "Single.", category: "bug")

    get root_path, params: { category: "other" }

    assert_response :success
    assert_select "article", count: 0
    assert_match "No feedback in this category", response.body
  end

  test "show back link preserves active category filter" do
    feedback = Feedback.create!(title: "Item", description: "Detail.", category: "bug")

    get feedback_path(feedback, category: "bug")

    assert_response :success
    assert_select "a[href=?]", root_path(category: "bug"), text: "Back to inbox"
  end

  test "update category redirect preserves filter param" do
    feedback = Feedback.create!(title: "Item", description: "Detail.", category: "other")

    patch feedback_path(feedback, category: "bug"), params: { feedback: { category: "bug" } }

    assert_redirected_to feedback_path(feedback, category: "bug")
  end

  test "index lists feedback newest first with required fields" do
    Feedback.delete_all
    older = Feedback.create!(title: "Older item", description: "First submitted.")
    newer = Feedback.create!(title: "Newer item", description: "Second submitted.")

    get root_path

    assert_response :success
    assert_select "h1", text: "Feedback inbox"
    assert_select "article h2", count: 2
    titles = css_select("article h2 a").map(&:text)
    assert_equal [newer.title, older.title], titles
    assert_match newer.category, response.body
    assert_match older.category, response.body
    assert_match newer.description, response.body
    assert_match older.description, response.body
    assert_select "time[datetime=?]", newer.created_at.iso8601
    assert_select "time[datetime=?]", older.created_at.iso8601
  end
end
