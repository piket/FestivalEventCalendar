Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
             # :scope => 'email,user_birthday,user_location'
             :scope => 'email'
end