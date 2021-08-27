class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required

  private

  def current_user
    if session[:user_id]
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
