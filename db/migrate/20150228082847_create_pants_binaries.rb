class CreatePantsBinaries < ActiveRecord::Migration
  def change
    create_table :pants_binaries, id: :uuid do |t|
      t.binary   :payload
      t.jsonb    :meta
      t.datetime :created_at, null: false
    end
  end
end
