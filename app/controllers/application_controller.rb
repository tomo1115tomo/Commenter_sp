class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required

  private

  def current_user
    if session[:user_id] && User.find_by(id:session[:user_id]) != nil
      @current_user ||= User.find_by(id:session[:user_id]).userid if session[:user_id]
    end
  end

  def login_required
    if current_user == nil
      redirect_to login_url
    end
  end

  def show
    @requests = Friend.where(friendid:current_user, request:true, allow:false).all
  end
end



def judge_ff(user, friend)
  followRequest = Friend.find_by(userid:user, friendid:friend)&.request
  followAllow = Friend.find_by(userid:user, friendid:friend)&.allow

  if followRequest == true && followAllow == true
    @follow = 20
  elsif followRequest == true && followAllow == false
    @follow = 10
  elsif followRequest == nil || followAllow == nil
    @follow = 0
  else
    @follow = 0
  end


  followerRequest = Friend.find_by(userid:friend, friendid:user)&.request
  followerAllow = Friend.find_by(userid:friend, friendid:user)&.allow

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
