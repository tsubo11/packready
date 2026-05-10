require 'rails_helper'

RSpec.describe "Items", type: :request do
  # テスト用のユーザー
  let(:user) { create(:user) }
  # 他のユーザー
  let(:other_user) { create(:user) }
  # テスト用のユーザーが作成したリスト
  let(:packing_list) { create(:packing_list, user: user) }
  # 他のユーザーが作成したリスト
  let(:other_packing_list) { create(:packing_list, user: other_user) }
  # テスト用の持ち物
  let(:item) { create(:item, packing_list: packing_list) }

  describe "GET /packing_lists/:packing_list_id/items" do
    context 'ログイン状態の場合' do
      it '持ち物が表示される' do
        sign_in user
        get "/packing_lists/#{packing_list.id}/items"
        expect(response).to have_http_status(200)
      end
    end

    context '他のユーザーのリストにアクセスした場合' do
      it 'エラー画面が表示される' do
        sign_in user
        get "/packing_lists/#{other_packing_list.id}/items"
        expect(response).to have_http_status(404)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移する' do
        get "/packing_lists/#{packing_list.id}/items"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe "POST /packing_lists/:packing_list_id/items" do
    context '持ち物追加成功した場合' do
      it '持ち物が表示される' do
        sign_in user
        post "/packing_lists/#{packing_list.id}/items", params: { item: { name: 'パスポート', timing: :day_before } }
        expect(response).to redirect_to(packing_list_items_path(packing_list))
      end
    end

    context '持ち物追加失敗した場合' do
      it 'バリデーションエラーになる' do
        sign_in user
        post "/packing_lists/#{packing_list.id}/items", params: { item: { name: ' ', timing: :day_before } },
                                                        headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response).to have_http_status(422)
      end
    end

    context '他のユーザーのリストにアクセスした場合' do
      it 'エラー画面が表示される' do
        sign_in user
        post "/packing_lists/#{other_packing_list.id}/items"
        expect(response).to have_http_status(404)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移する' do
        post "/packing_lists/#{other_packing_list.id}/items"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe "PATCH /packing_lists/:packing_list_id/items/:id/check" do
    context 'チェックボックスをクリックした場合' do
      it 'trueに切り替わる' do
        sign_in user
        patch "/packing_lists/#{packing_list.id}/items/#{item.id}/check"
        item.reload
        expect(item.checked).to be(true)
      end
    end

    context '他のユーザーのリストにアクセスした場合' do
      it 'エラー画面が表示される' do
        sign_in user
        patch "/packing_lists/#{other_packing_list.id}/items/#{item.id}/check"
        expect(response).to have_http_status(404)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移する' do
        patch "/packing_lists/#{other_packing_list.id}/items/#{item.id}/check"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe "PATCH /packing_lists/:packing_list_id/items/:id" do
    context '持ち物名の更新が成功した場合' do
      it '持ち物が表示される' do
        sign_in user
        patch "/packing_lists/#{packing_list.id}/items/#{item.id}", params: { item: { name: 'パスポート', timing: :day_before } }
        expect(response).to redirect_to(packing_list_items_path(packing_list))
      end
    end

    context '持ち物名の更新が失敗した場合' do
      it 'バリデーションエラーになる' do
        sign_in user
        patch "/packing_lists/#{packing_list.id}/items/#{item.id}", params: { item: { name: ' ', timing: :day_before } },
                                                                    headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response).to have_http_status(422)
      end
    end

    context '他のユーザーのリストにアクセスした場合' do
      it 'エラー画面が表示される' do
        sign_in user
        patch "/packing_lists/#{other_packing_list.id}/items/#{item.id}"
        expect(response).to have_http_status(404)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移する' do
        patch "/packing_lists/#{packing_list.id}/items/#{item.id}"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe "DELETE /packing_lists/:packing_list_id/items/:id" do
    context '持ち物の削除が成功した場合' do
      it '持ち物編集画面に遷移する' do
        sign_in user
        delete "/packing_lists/#{packing_list.id}/items/#{item.id}"
        expect(response).to redirect_to(packing_list_items_path(packing_list))
      end
    end

    context '他のユーザーのリストにアクセスした場合' do
      it 'エラー画面が表示される' do
        sign_in user
        delete "/packing_lists/#{other_packing_list.id}/items/#{item.id}"
        expect(response).to have_http_status(404)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面に遷移する' do
        delete "/packing_lists/#{other_packing_list.id}/items/#{item.id}"
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
