class CreatePackingLists < ActiveRecord::Migration[7.1]
  def change
    create_table :packing_lists do |t|
      t.string :name, null: false
      t.date :departure_date
      t.time :notification_time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
