require 'logger'
class FriendBroadcastJob < ApplicationJob
  queue_as :default

  def perform(data)
    logger = Logger.new('log.log')
    if data['request'] == false && data['allow'] == false
      logger.debug("check")
      friend = Friend.find_by(userid:data['userid'], friendid:data['friendid'])
      friend.destroy
    end

    ActionCable.server.broadcast "friend_channel", data: render_friend(data), userid:data['userid'], friendid:data['friendid'], request:data['request'], allow:data['allow']
  end
end

private
def render_friend(data)
  ApplicationController.renderer.render(partial: 'layouts/news', locals: { userid: data['userid'], friendid: data['friendid'] })
end
