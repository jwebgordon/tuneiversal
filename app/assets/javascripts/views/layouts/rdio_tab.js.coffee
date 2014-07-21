class Tuneiversal.Views.Layouts.RdioTab extends Backbone.Marionette.Layout
  template: 'layouts/rdio_tab'

  initialize: () ->

  get_user_collection: () ->
    collection = R.request 
      method: 'getTracksInCollection'
      content:
        user: R.currentUser.get('key')
        sort: 'artist'
      success: (res) =>
        console.log res
        @render_user_collection res.result

  render_user_collection: (songs) ->
    for song in songs
      rdio_song = new Tuneiversal.Models.Song
        title: song.name
        artist: song.artist
        song_url: "http://rdio.com#{song.url}"
        song_id: song.key
        service: 'rdio'
      song_view = new Tuneiversal.Views.Layouts.RdioSong model: rdio_song
      # Tuneiversal.layouts.player.queue.add rdio_song
      $('#rdio').append song_view.render().el



Tuneiversal.addInitializer () ->
  Tuneiversal.layouts.rdio_tab = new Tuneiversal.Views.Layouts.RdioTab
