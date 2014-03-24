class Retweet < ActiveRecord::Base
	belongs_to :user 
	belongs_to :micropost
	# belongs_to :micropost, :class_name => "micropost"
	has_many :users, :through => :microposts
	has_many :microposts, :through => :users
end
