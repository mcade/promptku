class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      @microposts = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  def vote
    value = params[:type] == "up" ? 1 : -1
    @micropost = Micropost.find_by(id: params[:id])
    @micropost.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back, notice: "Thank you for voting"
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :content1, :content2)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end