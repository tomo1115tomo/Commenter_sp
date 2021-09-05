require 'logger'
class FriendsController < ApplicationController

  def create

    logger = Logger.new('log.log')
    logger.debug("def create")
    if Friend.find_by(user_id: current_user.id, friend_id:friend_params[:friend_id], request:true, allow:false) == nil
      @friend = Friend.new(user_id: current_user.id, friend_id:friend_params[:friend_id], request:true, allow:false, roomid:nil)
      @friend.save
    end

    redirect_to users_path
  end

  def edit1
    @friend = Friend.find_by(user_id: friend_params[:friend_id], friend_id:friend_params[:user_id], request:true, allow:false)
    @friend.allow = true
    @friend.save

    redirect_to users_path
  end

  def edit2
    @friend = Friend.find_by(user_id:friend_params[:user_id] , friend_id:friend_params[:friend_id], request:true)
    @friend.request, @friend.allow = false, false
    @friend.save

    redirect_to users_path
  end

  def destroy
    @friend = Friend.find_by(user_id: friend_params[:user_id], friend_id:friend_params[:friend_id])
    @friend.destroy

    redirect_to users_path
  end

  private
    def friend_params
      params.permit(:user_id, :friend_id)
    end
end
