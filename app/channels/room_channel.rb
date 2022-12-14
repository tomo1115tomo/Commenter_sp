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
    Comment.create! content:data['content'], long_content:data['long_content'], title:data['title'], senderid:data['senderid'], sender_id:data['sender_id'].to_i, receiver_id:data['receiver_id'].to_i, room_id:data['room_id'].to_i, emotion:data['emotion'].to_i, expression:data['expression'].to_i
    RoomChannel.broadcast_to content:data['content'], long_content:data['long_content'], title:data['title'], senderid:data['senderid'], sender_id:data['sender_id'].to_i, receiver_id:data['receiver_id'].to_i, room_id:data['room_id'].to_i, emotion:data['emotion'].to_i, expression:data['expression'].to_i
    NewsChannel.broadcast_to content:data['content'], long_content:data['long_content'], senderid:data['senderid'], sender_id:data['sender_id'].to_i, receiver_id:data['receiver_id'].to_i, room_id:data['room_id'].to_i
    #RoomChannel.broadcast_to data['content'], data['senderid'], data['receiverid']
  end
end
