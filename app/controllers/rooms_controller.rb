class RoomsController < ApplicationController
  def index
  end

  def new
    @room = Room.new()
  end

  def create
    # フォームから送られてくるparamsには、❶チャットルーム名:name, ❷参加ユーザー名:user_ids[]が含まれている。
    @room = Room.new(room_params)
    if @room.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    room = Room.find(params[:id])
    room.destroy
    redirect_to root_path
  end
  
  private

  def room_params
    # ストロングパラメータ -許可記述のやり方-
    #   単数のパラメータを許可 -> :name属性
    #   複数のパラメータを許可 -> name属性: []
    params.require(:room).permit(:name, user_ids: [])
  end
end
