class AddDestinationAndDurationDaysToPackingLists < ActiveRecord::Migration[7.1]
  def change
    add_column :packing_lists, :destination, :string
    add_column :packing_lists, :duration_days, :integer
  end
end
