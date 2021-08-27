require 'logger'
# loggerの生成
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # jsで実行されたspeakのmessageを受け取り、room_channelのreceivedにブロードキャストする
    #ActionCable.server.broadcast 'room_channel', content: data['comment'], senderid: data['senderid'], receiverid: data['receiverid']
    Comment.create! content:data['content'], senderid:data['senderid'], receiverid:data['receiverid'], roomid:data['roomid'].to_i
    RoomChannel.broadcast_to content:data['content'], senderid:data['senderid'], receiverid:data['receiverid'], roomid:data['roomid'].to_i
    NewsChannel.broadcast_to content:data['content'], senderid:data['senderid'], receiverid:data['receiverid'], roomid:data['roomid'].to_i
    #RoomChannel.broadcast_to data['content'], data['senderid'], data['receiverid']
  end
end
