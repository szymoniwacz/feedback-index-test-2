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

  test "new form is accessible at root" do
    get root_path

    assert_response :success
    assert_select "form[action=?]", feedbacks_path
    assert_select "label", text: "Title"
    assert_select "label", text: "Description"
  end
end
