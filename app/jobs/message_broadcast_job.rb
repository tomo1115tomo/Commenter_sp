require "logger"
class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    create_date = get_comment_date(comment.created_at)
    create_time = get_comment_time(comment.created_at)
    tmp = create_date + " " + create_time
    ActionCable.server.broadcast "room_channel", comment: render_message(comment), content: comment.content, room_id: comment.room_id, sender_id:comment.sender_id, receiver_id:comment.receiver_id, created_at:tmp
    ActionCable.server.broadcast 'news_channel', news: render_message2(comment), senderid: comment.senderid, room_id: comment.room_id, sender_id:comment.sender_id, receiver_id:comment.receiver_id
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
