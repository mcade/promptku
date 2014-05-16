CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAIHD37RCXI24W6LLA',                        # required
    :aws_secret_access_key  => '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',                        # required
  	:region                 => 'us-east-1' 
  }
  config.fog_directory  = 'promptku-profile-images'                     # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end