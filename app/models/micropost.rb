class Micropost < ActiveRecord::Base
	belongs_to :user
  has_many :retweets
  has_reputation :votes, source: :user, aggregated_by: :sum
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true


  # validates :retweeter, :uniqueness => {scope: :user_id, :message => "You already retweeted"}
  # validates :retweet, :uniqueness => {scope: :current_user, :message => "You already retweeted"}
  def retweet_by(retweeter)
    if self.user == retweeter
      "Sorry, you can't retweet your own tweets"
    elsif self.retweets.where(:user_id => retweeter.id).present?
      "You already retweeted!"
    else
      t = Micropost.new
      t.content = "RT #{self.user.name}: #{self.content}"
      t.content1 = "#{self.content1}"
      t.user = retweeter
      t.save
      "Succesfully retweeted"
    end
  end

  def self.retweets
    micropost = Micropost.find(params[:id])
  end

	# Returns microposts from the users being followed by the given user.
  	def self.from_users_followed_by(user)
    	followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    	where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          	user_id: user.id)
  	end

end
