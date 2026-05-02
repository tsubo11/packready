class Item < ApplicationRecord
  # アソシエーション
  # itemはpacking_listに属している
  belongs_to :packing_list

  # バリデーション
  # 不完全なデータがDBに入るのを防ぐため入力必須とする
  validates :name, presence: true
  validates :timing, presence: true

  # 各タイミングを表す整数に対して、名前を割り当てる
  enum timing: { morning: 0, day_before: 1 }
end