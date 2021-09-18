require 'logger'
class UsersController < ApplicationController
  before_action :set_user #, only: %i[ show edit update destroy ]
  skip_before_action :login_required, {only: [:new, :create]}

  def index
    flag = 0
    @userss = []
    @users = []

    friend1 = Friend.where(user_id:current_user.id)
    friend2 = Friend.where(friend_id:current_user.id)
    friend1.each do |friend_id|
      last_msg_time1 = Comment.where(sender_id:friend_id.friend_id, receiver_id:current_user.id).last
      last_msg_time2 = Comment.where(sender_id:current_user.id, receiver_id:friend_id.friend_id).last
      last_msg_time1 = last_msg_time1.created_at unless last_msg_time1.nil?
      last_msg_time2 = last_msg_time2.created_at unless last_msg_time2.nil?
      if last_msg_time1 != nil && last_msg_time2 != nil
        if last_msg_time1 < last_msg_time2
          last_msg_time1 = last_msg_time2
        end
      elsif last_msg_time1 == nil
        last_msg_time1 = last_msg_time2
      end
      if User.find_by(id:friend_id.friend_id)
        @userss.push([User.find(friend_id.friend_id), last_msg_time1])
      end
    end
    friend2.each do |friend_id|
      last_msg_time1 = Comment.where(sender_id:friend_id.user_id, receiver_id:current_user.id).last
      last_msg_time2 = Comment.where(sender_id:current_user.id, receiver_id:friend_id.user_id).last
      last_msg_time1 = last_msg_time1.created_at unless last_msg_time1.nil?
      last_msg_time2 = last_msg_time2.created_at unless last_msg_time2.nil?
      if last_msg_time1 != nil && last_msg_time2 != nil
        if last_msg_time1 < last_msg_time2
          last_msg_time1 = last_msg_time2
        end
      end

      @userss.each do |user|
        if user[0] == User.find(friend_id.friend_id)
          flag = 1
          if user[1] != nil && user[1] < last_msg_time1
            user[1] = last_msg_time1
          end
        end
      end

      if flag == 0 && User.find_by(id:friend_id.friend_id)
        @userss.push([User.find(friend_id.friend_id), last_msg_time1])
      end
      flag = 0
    end

    @userss = @userss.sort {|a, b| a[1].to_s <=> b[1].to_s}.reverse
    @userss.each do |user|
      @users.push(user[0])
    end
  end

  def show
    if User.find(params[:id]) != nil
      @user = User.find(params[:id])
    else
      @user = nil
    end

    @users = User.all

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(current_user.id)
  end


  def select
    @user = User.find(current_user.id)
  end

  def search
    @q = User.ransack(params[:q])
    if params[:q] != nil
      @results = @q.result
    else
      @results = User.all.shuffle
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      if @user&.authenticate(user_params[:password])
        session[:user_id] = @user.id
        redirect_to users_path
      end
    else
      unless @user.valid?
        @user.errors.each do |key, value|
          flash.now[:alert] = value
        end
        render :new
      else
        render :new
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json

  #######編集中#######
  def update
    update_num = judge_update(user_edit_pw_params_confirmation[:current_password], user_edit_pw_params_confirmation[:password], user_edit_pw_params_confirmation[:password_confirmation])
    @user = User.find(current_user.id)

    case update_num
    when 111 then
      #現在のPWと一致する（＝本人確認が取れた場合）
      if @user&.authenticate(user_edit_pw_params_confirmation[:current_password])
        #新PWと新PW(確認)が一致する
        if user_edit_pw_params_confirmation[:password] == user_edit_pw_params_confirmation[:password_confirmation]
          #PWありとして更新する
          @user.update(user_edit_pw_params_update)
          flash[:notice] = "パスワードを変更しました"
          redirect_to users_path
        #新PWと新PW(確認)が一致しない
        else
          flash.now[:alert] = "新しいパスワード が一致しません"
          render :edit2
        end
      #現在のPWと一致しない（＝本人確認が取れていない場合）
      else
        flash.now[:alert] = "現在のパスワード が一致しません"
        render :edit2
      end

    when 0 then
      if user_edit_normal_params_confirmation[:flag].to_i == 1
        #名前、ユーザーIDやプロフィール写真といった情報のみを更新する
        @user.update(user_edit_normal_params_update)
        flash[:notice] = "ユーザー情報を更新しました"
        redirect_to users_path
      else
        flash.now[:alert] = "新たなパスワード と 新たなパスワード(確認) を入力してください"
        render :edit2
      end

    when 100 then
      flash.now[:alert] = "新たなパスワード と 新たなパスワード(確認) を入力してください"
      render :edit2

    when 101 then
      flash.now[:alert] = "新たなパスワード を入力してください"
      render :edit2

    when 110 then
      flash.now[:alert] = "新たなパスワード(確認) を入力してください"
      render :edit2

    when 1, 10, 11 then
      flash.now[:alert] = "現在のパスワード を入力してください"
      render :edit2

    else
      render :select
    end
  end



  # DELETE /users/1 or /users/1.json
  def destroy
    reset_session
    @user = User.find(params[:id])
    @user.destroy

    redirect_to login_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if current_user != nil
        @user = User.find(current_user.id)
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :userid, :password, :password_confirmation, :image, :name_cont, :q)
    end

    def user_edit_normal_params_confirmation
      params.require(:user).permit(:name, :userid, :current_password, :image, :name_cont, :q, :flag)
    end
    def user_edit_normal_params_update
      params.require(:user).permit(:name, :userid, :image, :name_cont, :q)
    end

    def user_edit_pw_params_confirmation
      params.require(:user).permit(:name, :userid, :password, :password_confirmation, :current_password, :image, :name_cont, :q)
    end
    def user_edit_pw_params_update
      params.require(:user).permit(:name, :userid, :password, :password_confirmation, :image, :name_cont, :q)
    end
end
