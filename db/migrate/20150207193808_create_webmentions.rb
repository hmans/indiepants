class CreateWebmentions < ActiveRecord::Migration
  def change
    create_table :pants_webmentions, id: :uuid do |t|
      t.string :source
      t.string :target
      t.uuid :source_document_id, index: true
      t.uuid :target_document_id, index: true

      t.timestamps null: false
    end
  end
end
