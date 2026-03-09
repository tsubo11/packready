class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.references :packing_list, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :timing, null: false, default: 0
      t.boolean :checked, null: false, default: false

      t.timestamps
    end
  end
end
