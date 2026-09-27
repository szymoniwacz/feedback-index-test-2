class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :category, null: false, default: "other"

      t.timestamps
    end
  end
end
