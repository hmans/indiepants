class CreateUsers < ActiveRecord::Migration
  def change
    create_table :pants_users, id: :uuid do |t|
      # URL
      t.string  :host,   null: false, index: { unique: true }
      t.string  :scheme, null: false, default: 'http'

      # Pants-specific
      t.string :password_digest
      t.boolean :local, null: false, default: false

      # Additional data
      t.string :name
      t.jsonb  :data, null: false, default: {}

      # Timestamps
      t.timestamps null: false
    end
  end
end
