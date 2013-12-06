class TestController < ApplicationController
	
  def login
  	@client = SoundCloud.new({
  			:client_id     => '0f8a3ab92bb2f82f2ad7e826bbc073da',
  			:client_secret => '417ecd4081ca6b103dc403cca2e29a61',
  			:redirect_uri  => 'http://localhost:1122/index',
		})
		redirect_to @client.authorize_url()
  	
  end

  def index
  	# @client.exchange_token(:code => params[:code])
  	# @tracks = @client.get('/tracks', :limit => 10, :order => 'hotness')
  end
end
