require "logger"
class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    ActionCable.server.broadcast "room_channel", comment: render_message(comment), room_id: comment.room_id, sender_id:comment.sender_id, receiver_id:comment.receiver_id
    ActionCable.server.broadcast 'news_channel', news: render_message2(comment), room_id: comment.room_id, sender_id:comment.sender_id, receiver_id:comment.receiver_id
  end




  private
  def render_message(comment)
    ApplicationController.renderer.render(partial: 'comments/comment', locals: { comment: comment })
  end

  private
  def render_message2(comment)
    ApplicationController.renderer.render(partial: 'layouts/news', locals: { news: comment })
  end
end
