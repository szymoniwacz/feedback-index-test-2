class FeedbacksController < ApplicationController
  def index
    @current_category_filter = Feedback.filter_category_param(params[:category])
    @filter_active = @current_category_filter.present?
    @inbox_empty = !Feedback.exists?

    scope = Feedback.ordered_for_inbox
    scope = scope.where(category: @current_category_filter) if @filter_active
    @feedbacks = scope
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
    @category_filter = params[:category]
  end

  def update
    @feedback = Feedback.find(params[:id])
    @category_filter = params[:category]

    if @feedback.update(category_params)
      redirect_to feedback_path(@feedback, category: preserved_category_filter)
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

  def preserved_category_filter
    filter = Feedback.filter_category_param(params[:category])
    filter.present? ? filter : nil
  end
end
