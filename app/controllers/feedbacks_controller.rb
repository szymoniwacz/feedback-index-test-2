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

  def update
    @feedback = Feedback.find(params[:id])

    if @feedback.update(category_params)
      redirect_to @feedback, notice: "Category updated."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :description)
  end

  def category_params
    params.require(:feedback).permit(:category)
  end
end
