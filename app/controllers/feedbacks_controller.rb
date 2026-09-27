class FeedbacksController < ApplicationController
  def index
    @feedbacks = Feedback.ordered_for_inbox
  end

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      redirect_to @feedback
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :description)
  end
end
