module Users
  # LINEログインのコールバックを処理するコントローラ
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # LINEからコールバックが来たときに呼ばれるアクション
    def line
      # LINEから届いたユーザー情報をもとに、ログインするユーザーを特定・作成する
      @user = User.from_omniauth(request.env["omniauth.auth"])

      # DBに保存済み（ログイン成功）の場合
      if @user.persisted?
        # ログイン処理をしてリダイレクトする
        sign_in_and_redirect @user, event: :authentication
        # ブラウザが通常のHTMLリクエストの場合のみ「LINEでログインしました」を表示する
        set_flash_message(:notice, :success, kind: "LINE") if is_navigational_format?
      else
        # ログイン失敗時：LINEの情報を一時的にセッションに保存して登録画面に戻す
        session["devise.line_data"] = request.env["omniauth.auth"].except("extra")
        redirect_to new_user_registration_url, alert: t("devise.omniauth_callbacks.failure")
      end
    end

    # ユーザーがLINEログインをキャンセルしたときに呼ばれるアクション
    def failure
      Rails.logger.error "OmniAuth failure: #{request.env['omniauth.error.type']} / #{request.env['omniauth.error']&.message}"
      redirect_to new_user_session_url, alert: t("devise.omniauth_callbacks.cancelled")
    end
  end
end
