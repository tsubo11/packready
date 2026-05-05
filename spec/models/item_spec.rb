require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'アソシエーション' do
    it { is_expected.to belong_to(:packing_list) }
  end

  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:timing) }
  end
  
  describe 'enum' do
    it { is_expected.to define_enum_for(:timing).with_values(morning: 0, day_before: 1) }
  end
end
