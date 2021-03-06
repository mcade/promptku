class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  around_filter :catch_not_found
  
    def index
      # @users = User.paginate(page: params[:page])
      # Using pg_search for full text search and kaminari gem to paginate
      @users = User.search(params[:query]).order('name ASC').page params[:page]
    end

	  def new
  		@user = User.new
  	end

  	def show
    	@user = User.find(params[:id])
      @microposts = @user.microposts.page(params[:page]).per(20)
      @micropost  = current_user.microposts.build
  	end

  	def create
  		@user = User.new(user_params)
    	if @user.save
        sign_in @user
    		flash[:success] = "Welcome to Promptku!"
      		redirect_to help_url
    	else
    		render 'new'
  		end
  	end

    def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end

    def edit
    end

    def update
      if @user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        render 'edit'
      end
    end

    def following
      @title = "Following"
      @user = User.find(params[:id])
      @users = @user.followed_users.page params[:page]
      render 'show_follow'
    end

    def followers
      @title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.page params[:page]
      render 'show_follow'
    end

  	private

    def user_params
    	params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :notifications, :image, :remote_image_url)
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def catch_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :flash => { :error => "Record not found." }
    end
end
