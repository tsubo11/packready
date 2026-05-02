class PackingList < ApplicationRecord
  
  # アソシエーション
  # packing_listはuserに属している
  belongs_to :user
  # packing_listは複数のitemを持つ。packing_listが削除されると、紐づくitemsも自動的に削除
  has_many :items, dependent: :destroy

  # バリデーション
  # 不完全なデータがDBに入るのを防ぐため入力必須とする
  validates :name, presence: true

  # 当日の持ち物準備の進捗を表すメソッド
  # 準備済みの持ち物の数と持ち物の総数をそれぞれカウントする
  def morning_progress
    morning_items = items.where(timing: :morning)
    { checked: morning_items.where(checked: true).count, total: morning_items.count }
  end

  # 前日までの持ち物準備の進捗を表すメソッド
  # 準備済みの持ち物の数と持ち物の総数をそれぞれカウントする
  def day_before_progress
    day_before_items = items.where(timing: :day_before)
    { checked: day_before_items.where(checked: true).count, total: day_before_items.count }
  end
end
