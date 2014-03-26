ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "promptku.com",
  :user_name            => "promptku",
  :password             => "foobar8844",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
