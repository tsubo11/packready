require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  # テスト用のユーザー
  let(:user) { create(:user) }

  describe 'POST /users/sign_in' do
    context 'ログイン成功した場合' do
      it "リスト一覧に遷移" do
        post "/users/sign_in", params: { user: { email: user.email, password: "password" } }
        expect(response).to redirect_to(packing_lists_path)
      end
    end

    context 'ログイン失敗した場合' do
      it "エラーメッセージが表示される" do
        post "/users/sign_in", params: { user: { email: user.email, password: "wrongpassword" } }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    context 'ログアウト成功した場合' do
      it 'トップ画面に遷移' do
        # ログインしてから
        post "/users/sign_in", params: { user: { email: user.email, password: "password" } }
        # ログアウトする
        delete "/users/sign_out"
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
