class CommentsController < ApplicationController
  def new
  end

  def create
    @comment = Comment.create(comments_params)
    @comment.save

    @user1, @user2 = @comment.senderid, @comment.receiverid
    if @user1 > @user2
      @user1, @user2 = @user2, @user1
    end
    roomid = Room.find_by(userid1:@user1, userid2:@user2).id

    redirect_to "/rooms/#{roomid}"
  end

  def index
  end

  private
  def comments_params
    params.require(:comment).permit(:content, :senderid, :receiverid, :roomid, :image)
  end
end
