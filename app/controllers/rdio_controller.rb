require 'rdio'
class RdioController < ApplicationController

  before_action :initialize_rdio

  def initialize_rdio
    @rdio = @rdio || Rdio.new(["2g3ywzsr4qjmz7ebj8nc9d7a", "HNcpEr8uMV"], [session[:at], session[:ats]])    
    
  end

  def login
    # puts session
   #   respond_to do |format|
   #      format.json { render json: @rdio }
  #   end
    session.clear
    callback_url = '/rdio/callback'
    puts callback_url
    url = @rdio.begin_authentication(callback_url)
    session[:rt] = @rdio.token[0]
    session[:rts] = @rdio.token[1]
    redirect url
  end

  def callback
    request_token = session[:rt]
    request_token_secret = session[:rts]
    verifier = params[:oauth_verifier]
    if request_token and request_token_secret and verifier
      # exchange the verifier and request token for an access token
      @rdio = Rdio.new([RDIO_CONSUMER_KEY, RDIO_CONSUMER_SECRET], 
                      [request_token, request_token_secret])
      @rdio.complete_authentication(verifier)
      # save the access token in cookies (and discard the request token)
      session[:at] = rdio.token[0]
      session[:ats] = rdio.token[1]
      session.delete(:rt)
      session.delete(:rts)
      # go to the home page
      redirect to('/')
    else
      # we're missing something important
      redirect to('/logout')
    end
  end



end