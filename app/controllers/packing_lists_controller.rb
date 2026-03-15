class PackingListsController < ApplicationController
  before_action :set_packing_list, only: [:show, :edit, :update]
  
  def index
    @packing_lists = current_user.packing_lists.order(departure_date: :asc)
  end

  def new
    @packing_list = current_user.packing_lists.build
  end

  def create
    @packing_list = current_user.packing_lists.build(packing_list_params)
    if @packing_list.save
      redirect_to packing_list_path(@packing_list), notice: "リストを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @morning_items = @packing_list.items.where(timing: :morning)
    @day_before_items = @packing_list.items.where(timing: :day_before)
  end

  def edit
  end

  def update
    if @packing_list.update(packing_list_params)
      redirect_to packing_list_path(@packing_list), notice: "リストを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_packing_list
    @packing_list = current_user.packing_lists.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  def packing_list_params
    params.require(:packing_list).permit(:name, :departure_date, :notification_time)
  end
end
