require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe 'POST /users' do
    context '新規登録成功した場合' do
      it 'リスト一覧画面に遷移する' do
        post '/users', params: { user: { email: 'new_user@example.com', password: 'password' } }
        expect(response).to redirect_to(packing_lists_path)
      end
    end

    context '新規登録失敗した場合' do
      it 'エラーメッセージが表示される' do
        post '/users', params: { user: { email: 'new_user@example.com', password: '' } }
        expect(response).to have_http_status(422)
      end
    end
  end
end
