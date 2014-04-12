class CommentsController < ApplicationController

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = Comment.create(comment_params)
    @comment.micropost = @micropost
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
         format.html { redirect_to :back }
         format.js
      else
        render 'shared/_comment_form'
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private
  def comment_params    
    params.require(:comment).permit(:micropost_id, :user_id, :comment_content)
  end
end