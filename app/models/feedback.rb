class Feedback < ApplicationRecord
  CATEGORIES = %w[bug feature\ request other].freeze

  scope :ordered_for_inbox, -> { order(created_at: :desc, id: :desc) }

  validates :title, presence: true
  validates :description, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  before_validation :default_category, on: :create

  private

  def default_category
    self.category = "other" if category.blank?
  end
end
