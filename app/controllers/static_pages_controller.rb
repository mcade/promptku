class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.page(params[:page]).per(3)
      @content_count = Micropost.count
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
