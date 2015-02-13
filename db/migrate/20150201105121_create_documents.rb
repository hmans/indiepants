class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :pants_documents, id: :uuid do |t|
      # Core attributes
      t.string :url,  null: false
      t.string :host, null: false, index: true
      t.string :path, null: false
      t.string :type
      t.string :title

      # Pants specific
      t.string :slug
      t.string :previous_urls, array: true, default: [], index: true

      # Body & Data
      t.text   :html
      t.json   :data, null: false, default: {}
      t.string :tags, array: true, default: [], index: true

      # Timestamps
      t.datetime :published_at, index: true
      t.datetime :deleted_at,   index: true
      t.timestamps null: false, index: true
    end
  end
end
