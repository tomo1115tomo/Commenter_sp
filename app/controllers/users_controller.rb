class UsersController < ApplicationController
  before_action :set_user #, only: %i[ show edit update destroy ]
  skip_before_action :login_required, {only: [:new, :create]}

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id:params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def my_profile
    @user = User.find_by(userid:current_user)
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
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: "User was successfully updated." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
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
      params.require(:user).permit(:name, :userid, :password, :password_confirmation, :image)
    end
end
