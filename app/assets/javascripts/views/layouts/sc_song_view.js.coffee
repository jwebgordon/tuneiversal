class Tuneiversal.Views.Layouts.SCSong extends Backbone.Marionette.ItemView
  template: 'layouts/sc_song'
  # el: '#soundcloud'

  events:
    'click .play-pause': 'play_pause'
    'click .stop': 'stop'
    'click .add-to-playlist': 'add_song_to_playlist'

  initialize: () ->
    console.log @
    @model.bind('change', @render)
    @model.view = @
    @playlists = new Tuneiversal.Collections.Playlists
    @songs_ready = new $.Deferred()
    @allSongs = new Tuneiversal.Collections.Songs
    @allSongs.fetch success: =>
      @songs_ready.resolve()
    @load_playlist_select()
  play_pause: () ->
    console.log 'play_pause called'
    if $('.playing').length > 0 and not @$el.hasClass 'playing'
      $('.playing .play-pause').click()
    if not @track
      promise = new $.Deferred()
      SC.stream "/tracks/#{@model.get 'song_id'}", (track) =>
        @track = track
        console.log 'track created'
        console.log @track
        promise.resolve()
        console.log promise
      promise.done () =>
        console.log 'promise ready'
        if not @model.get 'isPlaying'
          @track.play()
          @model.set isPlaying: true
          @$el.addClass 'playing'
          @swap_play_image()
    else
      if @model.get 'isPlaying'
        console.log 'attempting pause'
        @track.pause()
        @model.set isPlaying: false
        @$el.removeClass 'playing'
        @swap_play_image()
      else 
        @track.play()
        @model.set isPlaying: true
        @$el. addClass 'playing'
        @swap_play_image()

  stop: () ->
    if @track
      @track.stop()
      @model.set isPlaying: false
      @$el.removeClass 'playing'
      @swap_play_image()


  swap_play_image: () ->
    console.log @$el
    if @$el.hasClass 'playing'
      @$el.find('.play-pause').attr('src','/assets/audio_pause.png')
    else
      @$el.find('.play-pause').attr('src','/assets/audio_play.png')

  load_playlist_select: () ->
    allPlaylists = new Tuneiversal.Collections.Playlists
    allPlaylists.fetch success: =>
      for playlist in allPlaylists.models
        console.log playlist
        @$el.find('.playlist-dropdown-menu').append "<li><a tabindex='-1' class='add-to-playlist' data-playlist='#{playlist.id}'>#{playlist.attributes.title}</a></li>"

  add_song_to_playlist: (ev) ->
    playlist_id = $(ev.target).data('playlist')
    @song = @allSongs.findWhere service: @model.attributes.service, song_id: @model.attributes.song_id
    @songs_ready.done =>
      if not song == undefined
        console.log 'song did not exist'
        $.get("/api/add_song_to_playlist/#{playlist_id}/#{@song.id}")
      else
        console.log "song did exist #{@song}"
        waiting_id = new $.Deferred()
        @model.save {}, success: () ->
          console.log 'save success'
          waiting_id.resolve()
        waiting_id.done () =>
          $.get("/api/add_song_to_playlist/#{playlist_id}/#{@song.id}")




