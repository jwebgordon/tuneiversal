class Tuneiversal.Routers.Playlists extends Backbone.Router
  routes:
    '': 'index'


  index: ->
    playlists = new Tuneiversal.Collections.Playlists
    view = new Tuneiversal.Views.PlaylistsIndex collection: playlists
    playlists.fetch()
