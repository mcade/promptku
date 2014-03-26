class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy



  def index
    @microposts = Kaminari.paginate_array(Micropost.popular).page(params[:page]).per(25)
    @micropost  = current_user.microposts.build
  end

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

  def retweet
      micropost = Micropost.find_by(id: params[:id])
      retweet = micropost.retweet_by(current_user)
      if micropost.user == current_user
        redirect_to current_user, :notice => "Sorry, you can't retweet your own tweets"
      else
        redirect_to current_user, :notice => "Succesfully retweeted"
      end

  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :content1, :content2, :to)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end