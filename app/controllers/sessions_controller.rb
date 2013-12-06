class SessionsController < ApplicationController
 	def rdio
    unless params[:return_to].blank?
      session[:return_to] = params[:return_to]
    end
    redirect_to '/auth/rdio'
	end

	def create
    auth_hash = request.env['omniauth.auth']
    token = request.env['omniauth.strategy'].access_token.token
    user = User.sign_in_with_auth_hash(auth_hash, token)

    login_user(user)
    return_to_url(root_path)
	end

  def destroy
    logout_user
    return_to_url('/', notice: "You have successfully logged out")
  end


  def update
    ##update twitter
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

end