json.array!(@playlists) do |playlist|
  json.extract! playlist, 
  json.url playlist_url(playlist, format: :json)
end
