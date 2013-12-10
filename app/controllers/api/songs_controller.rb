class Api::SongsController < ApplicationController
	respond_to :json

  def get_songs_in_playlist
  	playlist = current_user.playlists.find(params[:playlist_id])
  	render json: playlist.songs
  end	
end