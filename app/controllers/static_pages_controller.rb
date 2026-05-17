class StaticPagesController < ApplicationController
  # 未ログインでもアクセス可能にする
  skip_before_action :authenticate_user!, only: %i[top terms privacy]
  
  # ログイン済みばらリスト一覧へ遷移
  def top
    redirect_to packing_lists_path if user_signed_in?
  end

  def terms; end
  def privacy; end
end