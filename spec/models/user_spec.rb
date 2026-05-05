require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'アソシエーション' do
    it { is_expected.to have_many(:packing_lists).dependent(:destroy) }
  end

  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password)}
  end
end
