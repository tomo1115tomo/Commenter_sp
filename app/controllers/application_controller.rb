require 'logger'
class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required

  private

  def current_user
    if session[:user_id] && User.find(session[:user_id]) != nil
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

  def login_required
    if current_user == nil
      redirect_to login_url
    end
  end

  def show
    @requests = Friend.where(friend_id:current_user.id, request:true, allow:false).all
  end
end



def judge_ff(user_id, friend_id)
  followRequest = Friend.find_by(user_id:user_id, friend_id:friend_id)&.request
  followAllow = Friend.find_by(user_id:user_id, friend_id:friend_id)&.allow

  if followRequest == true && followAllow == true
    @follow = 20
  elsif followRequest == true && followAllow == false
    @follow = 10
  elsif followRequest == nil || followAllow == nil
    @follow = 0
  else
    @follow = 0
  end


  followerRequest = Friend.find_by(user_id:friend_id, friend_id:user_id)&.request
  followerAllow = Friend.find_by(user_id:friend_id, friend_id:user_id)&.allow

  if followerRequest == true && followerAllow == true
    @follow += 2
  elsif followerRequest == true && followerAllow == false
    @follow += 1
  elsif followerRequest == nil || followerAllow == nil
    @follow += 0
  else
    @follow += 0
  end

  return @follow
end
