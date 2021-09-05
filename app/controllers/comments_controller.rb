class CommentsController < ApplicationController
  def new
  end

  def create
    @comment = Comment.create(comments_params)
    @comment.save

    @user_id1, @user_id2 = @comment.sender_id.to_i, @comment.receiver_id.to_i
    if @user_id1 > @user_id2
      @user_id1, @user_id2 = @user_id2, @user_id1
    end
    room_id = Room.find_by(user_id1:@user_id1, user_id2:@user_id2).id

    redirect_to "/rooms/#{room_id}"
  end

  def index
  end

  private
  def comments_params
    params.require(:comment).permit(:content, :sender_id, :receiver_id, :room_id, :image)
  end
end
