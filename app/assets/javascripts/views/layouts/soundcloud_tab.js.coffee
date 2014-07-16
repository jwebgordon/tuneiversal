class Tuneiversal.Views.Layouts.SoundcloudTab extends Backbone.Marionette.Layout
  template: 'layouts/soundcloud_tab'

  initialize: () ->
    # @get_favorites()

  get_favorites: () ->
    SC.get '/me', (me) =>
      @sc_me = me
      SC.get "/users/#{@sc_me.id}/favorites", (faves) =>
        @render_favorites faves

  render_favorites: (faves) ->
    songs = new Tuneiversal.Collections.Songs
    for song in faves
      sc_song = new Tuneiversal.Models.Song
        title: song.title
        artist: song.user.username
        song_url: song.uri
        song_id: song.id
        service: 'soundcloud'
      songs.add sc_song
      song_view = new Tuneiversal.Views.Layouts.SCSong model: sc_song
      Tuneiversal.layouts.player.queue.add sc_song
      $('#soundcloud').append song_view.render().el


Tuneiversal.addInitializer () ->
  Tuneiversal.layouts.soundcloud_tab = new Tuneiversal.Views.Layouts.SoundcloudTab