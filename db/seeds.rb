# Synthetic demo data for local Feedback Inbox walkthroughs.
# Idempotent: safe to run multiple times after db:prepare.

samples = [
  {
    title: "Export button missing on reports",
    description: "After the last update I cannot find CSV export on the reports page.",
    category: "bug",
    created_at: 3.days.ago
  },
  {
    title: "Dark mode for the inbox",
    description: "Would help when triaging feedback in the evening.",
    category: "feature request",
    created_at: 2.days.ago
  },
  {
    title: "Typo in welcome email",
    description: "The onboarding email says 'Feedbak' instead of 'Feedback'.",
    category: "other",
    created_at: 1.day.ago
  },
  {
    title: "Filter resets after submit",
    description: "When I submit while filtered to bugs, the list jumps back to All.",
    category: "bug",
    created_at: 12.hours.ago
  }
]

samples.each do |attrs|
  Feedback.find_or_create_by!(title: attrs[:title]) do |feedback|
    feedback.description = attrs[:description]
    feedback.category = attrs[:category]
    feedback.created_at = attrs[:created_at]
    feedback.updated_at = attrs[:created_at]
  end
end
