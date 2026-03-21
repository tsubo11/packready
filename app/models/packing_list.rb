class PackingList < ApplicationRecord
  validates :name, presence: true
  
  belongs_to :user
  has_many :items, dependent: :destroy

  def morning_progress
    morning_items = items.where(timing: :morning)
    { checked: morning_items.where(checked: true).count, total: morning_items.count }
  end

  def day_before_progress
    day_before_items = items.where(timing: :day_before)
    { checked: day_before_items.where(checked: true).count, total: day_before_items.count }
  end
end
