class Micropost < ActiveRecord::Base

  include PgSearch
   pg_search_scope :search_content, 
     against: [:content, :content1],
     using: {
       tsearch: { prefix: true, any_word: true } 
     }

  @@reply_to_regexp = /\A@([^\s]*)/
	belongs_to :user
  belongs_to :to, class_name: "User"
  has_many :comments, dependent: :destroy
  has_many :retweets
  has_reputation :votes, source: :user, aggregated_by: :sum
	default_scope -> { order('created_at DESC') }
  before_save :extract_in_reply_to
  scope :from_users_followed_by_including_replies, lambda { |user| followed_by_including_replies(user) }

	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true

  def self.popular
    reorder('votes desc').order('created_at DESC').find_with_reputation(:votes, :all)
    #find_with_reputation(:votes, :all, order: 'votes desc')
  end
  def self.popularToday
    reorder('votes desc').order('created_at DESC').find_with_reputation(:votes, :all, { :conditions => ["DATE(microposts.created_at) = DATE(NOW())"]})
  end
  def self.popularWeekly
    reorder('votes desc').order('created_at DESC').find_with_reputation(:votes, :all, { :conditions => ["EXTRACT(WEEK FROM microposts.created_at) = EXTRACT(WEEK FROM now())"]})
  end
  def self.popularMonthly
    reorder('votes desc').order('created_at DESC').find_with_reputation(:votes, :all, { :conditions => ["EXTRACT(MONTH FROM microposts.created_at) = EXTRACT(MONTH FROM now())"]})
  end



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


    def self.followed_by_including_replies(user)
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id OR to_id = :user_id",
            { :user_id => user })
    end
    def extract_in_reply_to
      if match = @@reply_to_regexp.match(content)
        user = User.find_by_shorthand(match[1])
        self.to=user if user
      end
    end

    def self.search(query)
      if query.present?
        search_content(query)
      else
        where(nil)
      end
   end

end
