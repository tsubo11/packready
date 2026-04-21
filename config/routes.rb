Rails.application.routes.draw do

  # Deviseが提供する認証関連のルーティングを一括生成
  devise_for :users

  # トップURL(/)にアクセスしたとき、StaticPagesControllerのtopアクションが実行される
  root "static_pages#top"

  # パッキングリストのルーティング
  resources :packing_lists, only: %i[ index new create show edit update destroy ] do
    # itemsは必ずpacking_listsに属するためネスト
    resources :items, only: %i[ index create update destroy ] do
      # 特定の1件に対して操作するという意味。memberを使用することでURLにitemのidが入る
      member do
        # checkdカラムのtrue/falseを更新する
        patch :check
      end
    end
  end

  # /upへのアクセスでアプリが動いているかのヘルスチェック。ステータスコード200で正常、５００で異常。
  get "up" => "rails/health#show", as: :rails_health_check
end
