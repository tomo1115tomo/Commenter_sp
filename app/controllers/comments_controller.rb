require 'logger'
class CommentsController < ApplicationController
  def new
  end

  def create
    @user_id1, @user_id2 = comments_params[:sender_id], comments_params[:receiver_id]
    if @user_id1 > @user_id2
      @user_id1, @user_id2 = @user_id2, @user_id1
    end
    room_id = Room.find_by(user_id1:@user_id1, user_id2:@user_id2).id

    if comments_params[:expression].to_i != 0
      if comments_params[:title] == ""
        flash[:notice] = "件名 を入力してください"
          comments = Comment.where(room_id:room_id, sender_id:current_user.id) + Comment.where(room_id:room_id, receiver_id:current_user.id)
          @comments = comments.sort {|a, b| a[:created_at] <=> b[:created_at]}
          @current_user_id = current_user.id
        render template: "rooms/show", :locals=>{:@room=>Room.find(room_id), :@comments=>@comments}
      elsif comments_params[:long_content] == ""
        flash[:notice] = "本文 を入力してください"
        render template: "rooms/show", :locals=>{:@room=>Room.find(room_id), :@comments=>@comments}
      else
        @comment = Comment.create(comments_params)
        @comment.save
        redirect_to "/rooms/#{room_id}"
      end
    else
      if comments_params[:content] == ""
        flash[:notice] = "本文 を入力してください"
        redirect_to "/rooms/#{room_id}"
      else
        @comment = Comment.create(comments_params)
        @comment.save
        redirect_to "/rooms/#{room_id}"
      end
    end
  end

  def index
  end

  private
  def comments_params
    params.require(:comment).permit(:content, :long_content, :title, :senderid, :sender_id, :receiver_id, :room_id, :image, :emotion, :expression)
  end
end
