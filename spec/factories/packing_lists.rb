FactoryBot.define do
  factory :packing_list do
    name { "テスト旅行" }
    association :user
  end
end
