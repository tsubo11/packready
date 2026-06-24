class PackingListsController < ApplicationController
  # 各アクションが動く前に、set_packing_listメソッドを実行
  # index, new, createは対象となる特定のリストがない
  before_action :set_packing_list, only: [:show, :edit, :update, :destroy]
  
  def index
    # ログイン中のユーザーのリストを、登録しているアイテムも含めて取得
    # 出発日が近い順に並べる
    @packing_lists = current_user.packing_lists.includes(:items).order(departure_date: :asc)
  end

  def show
    # 当日セクションの持ち物を取得
    @morning_items = @packing_list.items.where(timing: :morning)
    # 　前日セクションの持ち物を取得
    @day_before_items = @packing_list.items.where(timing: :day_before)
  end

  def new
    # ログイン中のユーザーに紐づくリストを作成するために空のオブジェクトを作ってビューに渡す
    @packing_list = current_user.packing_lists.build
  end

  def edit
  end

  def create
    # ログイン中のユーザーに紐づくリストを作成する
    @packing_list = current_user.packing_lists.build(packing_list_params)
    # 保存が成功した場合
    if @packing_list.save
      # 作成したリストの詳細画面に遷移する
      redirect_to packing_list_path(@packing_list), notice: "リストを作成しました"
    # 保存が失敗した場合
    else
      # リスト作成画面のまま、バリデーションエラー(422)
      render :new, status: :unprocessable_content
    end
  end

  def update
    # 取得したリスト情報の更新が成功した場合
    if @packing_list.update(packing_list_params)
      # 更新したリストの詳細画面に遷移する
      redirect_to packing_list_path(@packing_list), notice: "リストを更新しました"
    # 更新が失敗した場合
    else
      # リスト編集画面のまま、バリデーションエラー(422)
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    # 取得したリストを削除する
    @packing_list.destroy
    # リスト一覧画面
    redirect_to packing_lists_path, notice: "リストを削除しました"
  end

  private

  def set_packing_list
    # ログイン中のユーザーが作成しているリストの中から[:id]に一致するレコードを1件取得
    @packing_list = current_user.packing_lists.includes(:items).find(params[:id])
  # 該当レコードが見つからなかった場合の例外処理
  rescue ActiveRecord::RecordNotFound
    # publicディレクトリの'404.html'を表示する
    render file: Rails.public_path.join('404.html').to_s, status: :not_found, layout: false
  end

  def packing_list_params
    # フォームから送られてきたデータ全体からpacking_listのデータの受取を許可する
    params.require(:packing_list).permit(:name, :departure_date, :notification_time, :destination, :duration_days)
  end
end
