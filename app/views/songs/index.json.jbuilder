json.array!(@songs) do |song|
  json.extract! song, :song_id, :title, :artist, :service
  json.url song_url(song, format: :json)
end
