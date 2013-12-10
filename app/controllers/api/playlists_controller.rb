class Api::PlaylistsController < ApplicationController
  respond_to :json

  def index
    playlists = current_user.playlists
    respond_with playlists
  end

  def show
    playlists = current_user.playlists
    respond_with playlists, each_serializer: PlaylistSerializer
  end

  def add_song_to_playlist
  	playlist = Playlist.find(params[:playlist_id])
  	playlist.songs << Song.find(params[:song_id])
  	respond_with playlist.id
  end


end