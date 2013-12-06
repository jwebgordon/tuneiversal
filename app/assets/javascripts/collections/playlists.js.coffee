class Tuneiversal.Collections.Playlists extends Backbone.Collection

  model: Tuneiversal.Models.Playlist
  url: '/api/playlists.json'

  parse: (res) ->
    @models = res.playlists

