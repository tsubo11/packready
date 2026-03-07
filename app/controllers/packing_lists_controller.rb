class PackingListsController < ApplicationController
  def index
    @packing_lists = current_user.packing_lists.order(departure_date: :asc)
  end

  def new
    @packing_list = current_user.packing_lists.build
  end

  def create
    @packing_list = current_user.packing_lists.build(packing_list_params)
    if @packing_list.save
      redirect_to root_path, notice: "リストを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @packing_list = current_user.packing_lists.find(params[:id])
  end

  private

  def packing_list_params
    params.require(:packing_list).permit(:name, :departure_date, :notification_time)
  end
end
