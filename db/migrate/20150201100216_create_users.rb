class CreateUsers < ActiveRecord::Migration
  def change
    create_table :pants_users do |t|
      # URL etc.
      t.string :url,  null: false
      t.string :host, null: false, index: { unique: true }

      # Pants-specific
      t.string :password_digest
      t.boolean :local, null: false, default: false

      # Additional data
      t.string :name

      # Timestamps
      t.timestamps null: false
    end
  end
end
