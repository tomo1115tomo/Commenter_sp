require 'logger'
class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    user = User.find_by(userid: session_params[:userid])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to users_path
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end

  private
  def session_params
    params.require(:session).permit(:userid, :password, :roomid)
  end
end
