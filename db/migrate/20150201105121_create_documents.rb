class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :pants_documents, id: :uuid do |t|
      # Core attributes
      t.uuid   :user_id
      t.string :path, null: false
      t.string :type
      t.string :title

      # Pants specific
      t.string :slug
      t.string :previous_paths, array: true, default: []

      # Body & Data
      t.text   :html
      t.json   :data, null: false, default: {}
      t.string :tags, array: true, default: []

      # Timestamps
      t.datetime :published_at, index: true
      t.datetime :deleted_at,   index: true
      t.timestamps null: false, index: true
    end

    add_index :pants_documents, [:user_id, :path], unique: true
    add_index :pants_documents, [:user_id, :previous_paths]
    add_index :pants_documents, :tags

    add_foreign_key :pants_documents, :pants_users, column: :user_id
  end
end
