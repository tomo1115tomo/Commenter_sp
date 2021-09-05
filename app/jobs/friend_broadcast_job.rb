require 'logger'
class FriendBroadcastJob < ApplicationJob
  queue_as :default

  def perform(data)
    if data['request'] == false && data['allow'] == false
      friend = Friend.find_by(user_id:data['user_id'], friend_id:data['friend_id'])
      friend.destroy
    end

    ActionCable.server.broadcast "friend_channel", data: render_friend(data), user_id:data['user_id'], friend_id:data['friend_id'], request:data['request'], allow:data['allow']
  end
end

private
def render_friend(data)
  ApplicationController.renderer.render(partial: 'layouts/news', locals: { user_id: data['user_id'], friend_id: data['friend_id'] })
end
