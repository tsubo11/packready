require "rails_helper"

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  describe "POST /users/auth/line/callback" do
    let(:uid) { "U1234567890" }
    let(:email) { "test@example.com" }

    # OmniAuthのモックデータを設定するヘルパー
    def set_omniauth_mock(uid:, email: nil, email_verified: false)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new({
        provider: "line",
        uid: uid,
        info: { email: email },
        extra: { raw_info: { email_verified: email_verified } }
      })
    end

    context "LINE連携済みユーザーがログインする場合" do
      it "既存ユーザーでログインしてトップページにリダイレクトされる" do
        user = create(:user, provider: "line", uid: uid)
        set_omniauth_mock(uid: uid)

        post "/users/auth/line/callback"

        expect(response).to redirect_to(packing_lists_path)
      end
    end

    context "新規ユーザーがLINEログインする場合" do
      it "新しいユーザーが作成されてトップページにリダイレクトされる" do
        set_omniauth_mock(uid: uid)

        expect {
          post "/users/auth/line/callback"
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(packing_lists_path)
      end
    end

    context "メール連携済みユーザーがLINEログインする場合" do
      it "email_verifiedがtrueのとき既存アカウントに紐付けられる" do
        user = create(:user, email: email, provider: nil, uid: nil)
        set_omniauth_mock(uid: uid, email: email, email_verified: true)

        expect {
          post "/users/auth/line/callback"
        }.not_to change(User, :count)

        expect(response).to redirect_to(packing_lists_path)
      end

      it "email_verifiedがfalseのとき新規ユーザーが作成される" do
        create(:user, email: email, provider: nil, uid: nil)
        set_omniauth_mock(uid: uid, email: email, email_verified: false)

        expect {
          post "/users/auth/line/callback"
        }.to change(User, :count).by(1)
      end
    end

    context "認証に失敗した場合" do
      it "ログイン画面にリダイレクトされる" do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:line] = :invalid_credentials

        post "/users/auth/line/callback"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end