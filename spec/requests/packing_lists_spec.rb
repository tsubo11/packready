require 'rails_helper'

RSpec.describe "PackingLists", type: :request do
  # テスト用のユーザー
  let(:user) { create(:user) }
  # 他のユーザー
  let(:other_user) { create(:user) }
  # テスト用のユーザーが作成したリスト
  let(:packing_list) { create(:packing_list, user: user) }
  # 他のユーザーが作成したリスト
  let(:other_packing_list) { create(:packing_list, user: other_user) }

  describe 'GET /packing_lists' do
    context 'ログイン状態の場合' do
      it 'リスト一覧が表示される' do
        sign_in user
        get "/packing_lists"
        expect(response).to have_http_status(200)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移する' do
        get "/packing_lists"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'GET /packing_lists/:id' do
    context '自分のリストにアクセスした場合' do
      it '持ち物が表示される' do
        sign_in user
        get "/packing_lists/#{packing_list.id}"
        expect(response).to have_http_status(200)
      end
    end

    context '他のユーザーのリストにアクセスした場合' do
      it 'エラー画面が表示される' do
        sign_in user
        get "/packing_lists/#{other_packing_list.id}"
        expect(response).to have_http_status(404)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移する' do
        get "/packing_lists/#{packing_list.id}"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'POST /packing_lists' do
    context 'リスト作成が成功した場合' do
      it 'リスト詳細画面に遷移する' do
        sign_in user
        post "/packing_lists", params: { packing_list: { name: "テスト旅行" } }
        # (PackingList.last)で作成直後のリストを取得
        expect(response).to redirect_to(packing_list_path(PackingList.last))
      end
    end

    context 'リスト作成が失敗した場合' do
      it 'バリデーションエラーになる' do
        sign_in user
        post "/packing_lists", params: { packing_list: { name: "" } }
        expect(response).to have_http_status(422)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移する' do
        post "/packing_lists"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'PATCH /packing_lists/:id' do
    context '更新が成功した場合' do
      it 'リスト詳細画面に遷移する' do
        sign_in user
        patch "/packing_lists/#{packing_list.id}", params: { packing_list: { name: "テスト旅行" } }
        # 更新対象のリスト詳細画面に遷移
        expect(response).to redirect_to(packing_list_path(packing_list))
      end
    end

    context '更新が失敗した場合' do
      it 'バリデーションエラーになる' do
        sign_in user
        patch "/packing_lists/#{packing_list.id}", params: { packing_list: { name: "" } }
        expect(response).to have_http_status(422)
      end
    end

    context '他のユーザーのリストにアクセスした場合' do
      it 'エラー画面が表示される' do
        sign_in user
        patch "/packing_lists/#{other_packing_list.id}"
        expect(response).to have_http_status(404)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移する' do
        patch "/packing_lists/#{packing_list.id}"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'DELETE /packing_lists/:id' do
    context 'リスト削除が成功した場合' do
      it 'リスト一覧画面に遷移' do
        sign_in user
        delete "/packing_lists/#{packing_list.id}"
        expect(response).to redirect_to(packing_lists_path)
      end
    end

    context '他のユーザーのリストにアクセスした場合' do
      it 'エラー画面が表示される' do
        sign_in user
        delete "/packing_lists/#{other_packing_list.id}"
        expect(response).to have_http_status(404)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移' do
        delete "/packing_lists/#{packing_list.id}"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
