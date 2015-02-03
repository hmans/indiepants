class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # URL etc.
      t.string :host, null: false, index: { unique: true }
      t.string :url,  null: false

      # System related
      t.string :password_digest
      t.boolean :local, null: false, default: false

      # Additional data
      t.string :name

      # Timestamps
      t.timestamps null: false
    end
  end
end
