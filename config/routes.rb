Tuneiversal::Application.routes.draw do
  resources :songs

  resources :playlists

  devise_for :users
  root to: "soundcloud#index"
  get "soundcloud/index"
  get '/api/playlists', to: 'api/playlists#index'
  get '/api/add_song_to_playlist/:playlist_id/:song_id', to: 'api/playlists#add_song_to_playlist'
  get '/api/get_songs_in_playlist/:playlist_id', to: 'api/songs#get_songs_in_playlist'

end
