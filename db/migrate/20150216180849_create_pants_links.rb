class CreatePantsLinks < ActiveRecord::Migration
  def change
    create_table :pants_links, id: :uuid do |t|
      # Source
      t.uuid   :source_id,   null: false
      t.string :source_type, null: false

      # Target
      t.uuid   :target_id,   null: false
      t.string :target_type, null: false

      # etc.
      t.string :rel
      t.timestamps null: false
    end

    add_index :pants_links, [:source_id, :source_type, :target_id, :target_type, :rel],
      name: :source_and_target

    add_index :pants_links, [:target_id, :target_type, :rel]
  end
end
