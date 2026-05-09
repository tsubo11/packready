class ApplicationController < ActionController::Base
    # 未ログインの場合、ログイン画面に遷移
    before_action :authenticate_user!

    # ログイン後リスト一覧画面に遷移
    def after_sign_in_path_for(resource)
        packing_lists_path
    end

    # ログアウト後トップ画面に遷移
    def after_sign_out_path_for(resource_or_scope)
        root_path
    end
end
