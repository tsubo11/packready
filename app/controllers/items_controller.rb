class ItemsController < ApplicationController
  before_action :set_packing_list

  def index
    @morning_items = @packing_list.items.where(timing: :morning)
    @day_before_items = @packing_list.items.where(timing: :day_before)
  end

  def new
    @item = @packing_list.items.build
    @item.timing = params[:timing] if params[:timing].present?
  end

  def create
    @item = @packing_list.items.build(item_params)
    if @item.save
      redirect_to packing_list_items_path(@packing_list), notice: "アイテムを追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def check
    @item = @packing_list.items.find(params[:id])
    @item.update!(checked: !@item.checked)
  end

  def edit
    @item = @packing_list.items.find(params[:id])
  end

  def update
    @item = @packing_list.items.find(params[:id])
    if @item.update(item_params)
      redirect_to packing_list_items_path(@packing_list), notice: "持ち物を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = @packing_list.items.find(params[:id])
    @item.destroy
    redirect_to packing_list_items_path(@packing_list), notice: "持ち物を削除しました"
  end

  private

  def set_packing_list
    @packing_list = current_user.packing_lists.find(params[:packing_list_id])
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  def item_params
    params.require(:item).permit(:name, :timing)
  end
end