class MessagesController < ApplicationController
  def index
  # @messageで、チャットを保存していく。
    @message = Message.new
  # roomとmessageは親子関係なので、indexアクションに飛んできたとき、paramsにroom_idが格納されている。
    @room = Room.find(params[:room_id])
  # @room.messages : チャットルームに紐づいている全てのメッセージは、user_idと紐づいている。
  # includes(:user) : 一度の参照で、全ての紐付けを獲得することで、N+1問題を解消している。
    @messages = @room.messages.includes(:user)
  end

  def create
    # Roomレコードから、現在の部屋情報を引き出す
    @room = Room.find(params[:room_id])
    # その部屋情報に紐づく、チャット情報(ユーザーid含む)を新たに保存する。
    @message = @room.messages.new(message_params)
    if  @message.save
      redirect_to room_messages_path(@room)
    else
      @messages = @room.messages.includes(:user)
      render :index
    end
  end

  private

  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
  end

end
