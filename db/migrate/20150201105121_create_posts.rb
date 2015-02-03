class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, id: :uuid do |t|
      # Core attributes
      t.string :host, null: false

      # URL handling
      t.string :slug
      t.string :url
      t.string :previous_urls, array: true, default: []

      # Body & Data
      t.string :body
      t.string :body_html

      # Timestamps
      t.datetime :published_at, index: true
      t.timestamps null: false, index: true
    end
  end
end
