class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy, :likes, :votes]
  before_action :correct_user,   only: :destroy

  around_filter :catch_not_found



  def index
    if signed_in?
      @micropost  = current_user.microposts.build
    end
    #@microposts = Micropost.search(params[:query]).page params[:page]
    @microposts = case params["show"]
      when "daily"
          Kaminari.paginate_array(Micropost.popularToday).page(params[:page]).per(20)
      when "monthly"
          Kaminari.paginate_array(Micropost.popularMonthly).page(params[:page]).per(20)
      when "matching_prompts"
        matching = Micropost.where(content: params[:content])
        Kaminari.paginate_array(matching).page(params[:page]).per(20)
      else
        if params[:tag].present? && params["show"].nil?
          Kaminari.paginate_array(Micropost.tagged_with(params[:tag])).page(params[:page]).per(20)
        else
          Kaminari.paginate_array(Micropost.popularWeekly).page(params[:page]).per(20)
        end
    end
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comment = Comment.new
  end

  def likes
    @user = User.find(params[:id])
    @micropost  = current_user.microposts.build
    @microposts = Kaminari.paginate_array(Micropost.evaluated_by(:votes, User.find(params[:id])).reorder('rs_evaluations.created_at DESC')).page(params[:page]).per(25)
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.content1.blank?
      @micropost.content1 = "..."
    end
    if @micropost.save
      url = Bitly.client.shorten("https://www.promptku.com/microposts/#{@micropost.id}")
      @micropost.update_attributes :content2 => (url.short_url).gsub!("http://", "")
      respond_to do |format|
        format.html {redirect_to root_url}
        format.js
      end
    else
      @feed_items = []
      @microposts = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def vote
    value = params[:type] == "up" ? 1 : 0
    @micropost = Micropost.find_by(id: params[:id])
    unless @micropost.has_evaluation?(:votes, current_user)
      @micropost.add_or_update_evaluation(:votes, value, current_user)
    else
      @micropost.delete_evaluation(:votes, current_user)
    end
    respond_to do |format|
      format.html {redirect_to :back }
      format.js
    end
  end

  def retweet
      @micropost = Micropost.find_by(id: params[:id])
      retweet = @micropost.retweet_by(current_user)
      respond_to do |format|
        if @micropost.user == current_user
          format.html { redirect_to current_user, :notice => "Sorry, you can't retweet your own tweets" }
          format.js { render :partial => 'shared/errors' }
        else
          format.html { redirect_to current_user, :notice => "Succesfully retweeted".html_safe }
          format.js
        end
      end

  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :content1, :content2, :to, :tag_list)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def catch_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :flash => { :error => "Record not found." }
    end
end