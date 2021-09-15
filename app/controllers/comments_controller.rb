require 'logger'
class CommentsController < ApplicationController
  def new
  end

  def create
    @comment = Comment.create(comments_params)

    if params[:emotion_0]
      @comment.emotion = 0
    elsif params[:emotion_1]
      @comment.emotion = 1
    elsif params[:emotion_2]
      @comment.emotion = 2
    elsif params[:emotion_3]
      @comment.emotion = 3
    elsif params[:emotion_4]
      @comment.emotion = 4
    else
      @comment.emotion = 1
    end

    if params[:expression_1]
      @comment.expression = 1
    elsif params[:expression_2]
      @comment.expression = 2
    elsif params[:expression_3]
      @comment.expression = 3
    end
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
    params.require(:comment).permit(:content, :title, :senderid, :sender_id, :receiver_id, :room_id, :image, :emotion, :expression)
  end
end
