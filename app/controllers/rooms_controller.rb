class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show edit update destroy ]

  # GET /rooms or /rooms.json

  # GET /rooms/1 or /rooms/1.json
  def show
    comments = Comment.where(room_id:@room.id, sender_id:current_user.id) + Comment.where(room_id:@room.id, receiver_id:current_user.id)
    @comments = comments.sort {|a, b| a[:created_at] <=> b[:created_at]}
    @current_user_id = current_user.id
  end

  # GET /rooms/new

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms or /rooms.json
  def create
    user1 = User.find(room_params[:user_id1])
    user2 = User.find(room_params[:user_id2])

    if Room.find_by(user_id1:user1.id, user_id2:user2.id) == nil
      @room = Room.new(room_params)
      @room.save
      redirect_to "/rooms/#{@room.id}"
    else
      roomid = Room.find_by(user_id1:user1.id, user_id2:user2.id).id
      redirect_to "/rooms/#{roomid}"
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: "Room was successfully updated." }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: "Room was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      if Room.exists?(params[:id])
        @room = Room.find(params[:id])
      else
        redirect_to users_path
      end
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.permit(:user_id1, :user_id2)
    end
end
