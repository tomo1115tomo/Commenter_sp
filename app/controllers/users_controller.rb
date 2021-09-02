class UsersController < ApplicationController
  before_action :set_user #, only: %i[ show edit update destroy ]
  skip_before_action :login_required, {only: [:new, :create]}

  def index
    @users = User.all
  end

  def show
    if User.find_by(id:params[:id]) != nil
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
  def update
    if user_params[:password] != user_params[:password_confirmation]
      render :edit
    else
       @user.update(user_params)
    end

    redirect_to users_path
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    reset_session
    @user = User.find(params[:id])
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if params[:id] != nil
        @user = User.find_by(userid:current_user)
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :userid, :password, :password_confirmation, :image, :name_cont, :q)
    end
end
