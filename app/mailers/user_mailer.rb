class UserMailer < ActionMailer::Base
  default from: "promptku@gmail.com"

  def follower_notification(followed, follower)
  	@followed = followed 
  	@follower = follower
  	mail(to: "#{followed.name} <#{followed.email}>", 
  		subject: "You have a new follower")
  end

  def password_reset(user)
  	@user = user 
  	mail(to: "#{user.name} <#{user.email}>", subject: 'Password reset')
  end
end