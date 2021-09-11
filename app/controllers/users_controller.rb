require 'logger'
class UsersController < ApplicationController
  before_action :set_user #, only: %i[ show edit update destroy ]
  skip_before_action :login_required, {only: [:new, :create]}

  def index
    @users = User.all
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
  end


  def select
    @user = User.find(params[:id])
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
      render :new
    end
  end

  # PATCH/PUT /users/1 or /users/1.json

  #######編集中#######
  def update
    @user = User.find(params[:id])

    #新PWと新PW(確認)がともに空白でない場合（＝PW更新の意志がある場合）
    if user_edit_pw_params_confirmation[:password].blank? == false && user_edit_pw_params_confirmation[:password_confirmation].blank? == false
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
          flash.now[:alert] = "新しいパスワードが一致しません"
          render :edit2
        end
      #現在のPWと一致しない（＝本人確認が取れていない場合）
      else
        flash.now[:alert] = "現在のパスワードが一致しません"
        render :edit2
      end
    #新PWと新PW(確認)がともに空白の場合（＝PW更新の意志がない場合）
    elsif user_edit_pw_params_confirmation[:password].blank? && user_edit_pw_params_confirmation[:password_confirmation].blank?
      #名前、ユーザーIDやプロフィール写真といった情報のみを更新する
      @user.update(user_edit_normal_params_update)
      flash[:notice] = "ユーザー情報を更新しました"
      redirect_to users_path
    #新PWと新PW(確認)のいずれかが空白の場合（＝PW更新の意志があるか分からない場合）
    elsif user_edit_pw_params_confirmation[:password].blank?
      flash.now[:alert] = "新たなパスワードを入力してください"
      render :edit1
    elsif user_edit_pw_params_confirmation[:password_confirmation].blank?
      flash.now[:alert] = "新たなパスワード(確認)を入力してください"
      render :edit1
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
      if params[:id] != nil
        @user = User.find(current_user.id)
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :userid, :password, :password_confirmation, :image, :name_cont, :q)
    end

    def user_edit_normal_params_confirmation
      params.require(:user).permit(:name, :userid, :current_password, :image, :name_cont, :q)
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
