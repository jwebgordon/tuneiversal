class Tuneiversal.Collections.Songs extends Backbone.Collection
  url: '/songs'
  model: Tuneiversal.Models.Song

  initialize: (playlist_id = undefined) ->
   if playlist_id?
    console.log 'had id'
    console.log playlist_id
    @playlist_id = playlist_id
    @url = "/api/get_songs_in_playlist/#{playlist_id}"

  parse: (response) ->
    if @playlist_id?
      response.songs
    else
      response

