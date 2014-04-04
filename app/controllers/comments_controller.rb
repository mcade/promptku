class CommentsController < ApplicationController

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = Comment.create(comment_params)
    @comment.micropost = @micropost
    @comment.user = current_user
    if @comment.save
       flash[:success] = "Comment created!"
       redirect_to :back
    else
      render 'shared/_comment_form'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted."
    redirect_to :back
  end

  private
  def comment_params    
    params.require(:comment).permit(:micropost_id, :user_id, :comment_content)
  end
end