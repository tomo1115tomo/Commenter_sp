class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    ActionCable.server.broadcast "room_channel", comment: render_message(comment), roomid: comment.roomid, senderid:comment.senderid, receiverid:comment.receiverid
    ActionCable.server.broadcast 'news_channel', news: render_message2(comment), roomid: comment.roomid, senderid:comment.senderid, receiverid:comment.receiverid
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
