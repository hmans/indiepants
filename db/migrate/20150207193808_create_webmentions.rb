class CreateWebmentions < ActiveRecord::Migration
  def change
    create_table :webmentions, id: :uuid do |t|
      t.belongs_to :user, index: true
      t.string :source
      t.string :target
      t.uuid :source_post_id, index: true
      t.uuid :target_post_id, index: true

      t.timestamps null: false
    end
  end
end
