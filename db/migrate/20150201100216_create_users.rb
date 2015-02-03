class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :host, null: false, index: { unique: true }
      t.string :password_digest
      t.string :name

      t.boolean :local, null: false, default: false

      t.timestamps null: false
    end
  end
end
