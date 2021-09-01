require 'logger'
class FriendsController < ApplicationController

  def create

    logger = Logger.new('log.log')
    logger.debug("def create")
    if Friend.find_by(userid: current_user, friendid:friend_params[:friendid], request:true, allow:false) == nil
      @friend = Friend.new(userid: current_user, friendid:friend_params[:friendid], request:true, allow:false, roomid:nil)
      @friend.save
    end

    redirect_to users_path
  end

  def edit1
    logger = Logger.new('log.log')
    logger.debug(friend_params[:friendid] + "=>" + current_user)
    @friend = Friend.find_by(userid: friend_params[:friendid], friendid:friend_params[:userid], request:true, allow:false)
    @friend.allow = true
    @friend.save

    redirect_to users_path
  end

  def edit2
    @friend = Friend.find_by(userid:friend_params[:userid] , friendid:friend_params[:friendid], request:true)
    @friend.request, @friend.allow = false, false
    @friend.save

    redirect_to users_path
  end

  def destroy
    @friend = Friend.find_by(userid: friend_params[:userid], friendid:friend_params[:friendid])
    @friend.destroy

    redirect_to users_path
  end

  private
    def friend_params
      params.permit(:userid, :friendid)
    end
end
