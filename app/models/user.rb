class User < ActiveRecord::Base

# Using the pg_search gem to use Postgresql's full-text-search capabilities
# See https://github.com/Casecommons/pg_search
   include PgSearch
   pg_search_scope :search_name_and_username, 
     against: [:name, :email],
     using: {
       tsearch: { prefix: true, any_word: true } 
     }

  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
	before_save { self.email = email.downcase }
	before_create :create_remember_token

  has_many :retweets, :through => :microposts
  has_many :replies, foreign_key: "to_id", class_name: "Micropost"
  
	validates :name,  presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  	validates :email,	presence: true, format: { with: VALID_EMAIL_REGEX },
  						uniqueness: { case_sensitive: false }
  	has_secure_password
  validates :password, length: { minimum: 6 }
  has_many :evaluations, class_name: "RSEvaluation", as: :source
  has_reputation :votes, source: {reputation: :votes, of: :microposts}, aggregated_by: :sum



  	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.hash(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

    def feed
      Micropost.from_users_followed_by_including_replies(self)
    end

    def following?(other_user)
      relationships.find_by(followed_id: other_user.id)
    end

    def follow!(other_user)
      relationships.create!(followed_id: other_user.id)
    end

    def unfollow!(other_user)
      relationships.find_by(followed_id: other_user.id).destroy
    end

    def shorthand
     # name.gsub(/\s*/,"")
     name.gsub(/ /,"_")
    end
    def self.shorthand_to_name(sh)
     # name.gsub(/\s*/,"")
     sh.gsub(/_/," ")
    end
    def self.find_by_shorthand(shorthand_name)
      all = where(name: User.shorthand_to_name(shorthand_name))
      all
      return nil if all.empty?
      all.first
    end

    def self.search(query)
      if query.present?
        search_name_and_username(query)
      else
        where(nil)
      end
   end

    def send_follower_notification(follower)
      UserMailer.follower_notification(self, follower).deliver if notifications?
    end

    def send_password_reset
      token = SecureRandom.urlsafe_base64
      update_attribute(:password_reset_token, token)
      update_attribute(:password_reset_sent_at, Time.zone.now)
      UserMailer.password_reset(self).deliver
    end

    def invalidate_password_reset
      update_attribute(:password_reset_token, nil)
    end

  	private

	    def create_remember_token
	    	self.remember_token = User.hash(User.new_remember_token)
	    end

end
