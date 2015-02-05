class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, id: :uuid do |t|
      # Core attributes
      t.string :host, null: false
      t.string :type

      # URL handling
      t.string :slug
      t.string :url
      t.string :previous_urls, array: true, default: [], index: { using: :gin }

      # Body & Data
      t.jsonb  :data, null: false, default: {}
      t.text   :html

      # Timestamps
      t.datetime :published_at, index: true
      t.timestamps null: false, index: true
    end
  end
end
