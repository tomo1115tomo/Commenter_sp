class FriendsController < ApplicationController
  def new
  end

  def create
    @friend = Friend.new(userid: current_user, friendid:friend_params[:friendid], request:true, allow:false, roomid:nil)
    @friend.save

    redirect_to "/"
  end

  def edit
    @friend = Friend.find_by(userid: friend_params[:friendid], friendid:current_user, request:true, allow:false)
    @friend.allow = true
    @friend.save

    redirect_to "/"
  end

  def destroy
    @friend = Friend.find_by(userid: friend_params[:userid], friendid:friend_params[:friendid])
    @friend.destroy

    redirect_to "/"
  end

  private
    def friend_params
      params.permit(:userid, :friendid)
    end
end
