class ItemsController < ApplicationController
  # 各アクションが動く前に、set_packing_listメソッドを実行
  before_action :set_packing_list

  def index
    # 当日セクションの持ち物を取得
    @morning_items = @packing_list.items.where(timing: :morning)
    # 前日セクションの持ち物を取得
    @day_before_items = @packing_list.items.where(timing: :day_before)
    # 持ち物追加モーダルはindexの中に埋め込んでいる
    # 空のオブジェクトを作ってビューに渡す
    @item = @packing_list.items.build
  end

  def create
    # リストに属する持ち物を作成する
    @item = @packing_list.items.build(item_params)
    # 保存成功した場合
    if @item.save
      # 最新のアイテム一覧を保存直後に再取得
      @morning_items = @packing_list.items.where(timing: :morning)
      @day_before_items = @packing_list.items.where(timing: :day_before)
      # 保存の都度、空のオブジェクトを用意しておく
      @item = @packing_list.items.build
      # リクエストの形式によって返すレスポンスを変える
      respond_to do |format|
        # create.turbo_stream.erb を実行する
        format.turbo_stream
        # Turboが使えない環境のとき
        format.html { redirect_to packing_list_items_path(@packing_list) }
      end
    # 保存失敗した場合
    else
      respond_to do |format|
        # error.turbo_stream.erb を422ステータスで返す
        format.turbo_stream { render :error, status: :unprocessable_content }
        format.html { redirect_to packing_list_items_path(@packing_list) }
      end
    end
  end

  def check
    # リストに属する持ち物を取得する
    @item = @packing_list.items.find(params[:id])
    # チェックボックスをクリックするたびに true ↔ false が切り替わる
    @item.update(checked: !@item.checked)
  end

  def update
    # リストに属する持ち物を取得する
    @item = @packing_list.items.find(params[:id])
    # 持ち物名の更新が成功した場合
    if @item.update(item_params)
      # リクエストの形式によって返すレスポンスを変える
      respond_to do |format|
        # update.turbo_stream.erb を実行する
        format.turbo_stream
        # Turboが使えない環境のとき
        format.html { redirect_to packing_list_items_path(@packing_list) }
      end
    # 更新失敗した場合
    else
      respond_to do |format|
        # error_update.turbo_stream.erb を422ステータスで返す
        format.turbo_stream { render :error_update, status: :unprocessable_content }
        format.html { redirect_to packing_list_items_path(@packing_list) }
      end
    end
  end

  def destroy
    # リストに属する持ち物を取得する
    @item = @packing_list.items.find(params[:id])
    # 該当の持ち物削除
    @item.destroy
    # 削除完了後、持ち物編集画面再表示
    redirect_to packing_list_items_path(@packing_list), notice: "持ち物を削除しました"
  end

  private

  def set_packing_list
    # ログイン中のユーザーが作成しているリストの中から[:packing_list_id]に一致するレコードを1件取得
    @packing_list = current_user.packing_lists.find(params[:packing_list_id])
  # 該当レコードが見つからなかった場合の例外処理
  rescue ActiveRecord::RecordNotFound
    # publicディレクトリの'404.html'を表示する
    render file: Rails.public_path.join('404.html').to_s, status: :not_found, layout: false
  end

  def item_params
    # フォームから送られてきたデータ全体からitemのnameとtimingを受取許可する
    params.require(:item).permit(:name, :timing)
  end
end