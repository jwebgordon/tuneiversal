class Tuneiversal.Views.Layouts.Playlist extends Backbone.Marionette.ItemView
  template: 'layouts/playlist'

  events:
    'click .playlist': 'render_playlist'

  initialize: () ->
    @model.bind 'change', @render
    @model.view = @

  render_playlist: () ->
    $('#playlist-right').html ''
    if @model.songs?
      console.log 'already had songs'
      @songs = @model.songs
      for song in @songs.models
          if song.get('service') == 'soundcloud'
            song_view = new Tuneiversal.Views.Layouts.SCSong model: song
            $('#playlist-right').append song_view.render().el
            @model.songs = @songs
          else if song.get('service') == 'rdio'
            song_view = new Tuneiversal.Views.Layouts.RdioSong model: song
            $('#playlist-right').append song_view.render().el
            @model.songs = @songs
    else
      console.log 'fetching songs'
      @songs = new Tuneiversal.Collections.Songs @model.id
      @songs.fetch success: () =>
        for song in @songs.models
          if song.get('service') == 'soundcloud'
            song_view = new Tuneiversal.Views.Layouts.SCSong model: song
            $('#playlist-right').append song_view.render().el
            @model.songs = @songs
          else if song.get('service') == 'rdio'
            song_view = new Tuneiversal.Views.Layouts.RdioSong model: song
            $('#playlist-right').append song_view.render().el
            @model.songs = @songs
        console.log @model

      $('.playlist.active').removeClass('active')
      @$el.addClass('active')

