class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :host, index: { unique: true }
      t.string :name

      t.timestamps null: false
    end
  end
end
