ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "www.promptku.com",
  :user_name            => "promptku",
  :password             => "yosoy882",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = 'http://desolate-savannah-3068.herokuapp.com'