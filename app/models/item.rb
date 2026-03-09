class Item < ApplicationRecord
  belongs_to :packing_list

  enum timing: { morning: 0, day_before: 1 }

  validates :name, presence: true
  validates :timing, presence: true
end