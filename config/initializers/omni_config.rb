Rails.application.config.middleware.use OmniAuth::Builder do
  provider :rdio, ENV['2g3ywzsr4qjmz7ebj8nc9d7a'], ENV['HNcpEr8uMV']
end