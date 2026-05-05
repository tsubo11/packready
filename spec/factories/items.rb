FactoryBot.define do
  factory :item do
    name { "パスポート" }
    timing { :day_before }
    association :packing_list
  end
end
