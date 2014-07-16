class Tuneiversal.Views.Layouts.SCSong extends Backbone.Marionette.ItemView
  template: 'layouts/sc_song'
  # el: '#soundcloud'

  events:
    'click .play-pause': 'play_pause'
    'click .stop': 'stop'
    'click .add-to-playlist': 'add_song_to_playlist'
    'click .dropdown-toggle': 'load_playlist_select'

  initialize: () ->
    @model.bind('change', @render)
    @model.view = @
    # @playlists = new Tuneiversal.Collections.Playlists
     
    @allSongs = new Tuneiversal.Collections.Songs
    @allSongs.fetch success: =>
      @songs_ready.resolve()
    
  play_pause: () ->
    # if $('.playing').length > 0 and not @$el.hasClass 'playing'
    #   $('.playing .play-pause').click()
    console.log 'play pause called'
    if Tuneiversal.activeSong? and not @model.get('isPlaying')
      Tuneiversal.activeSong.view.stop()
    if not @track
      promise = new $.Deferred()
      SC.stream "/tracks/#{@model.get 'song_id'}", (track) =>
        @track = track
        promise.resolve()
      promise.done () =>
        if not @model.get 'isPlaying'
          @track.play()
          @model.set isPlaying: true
          Tuneiversal.activeSong = @model
          @$el.addClass 'playing'
          @swap_play_image()
    else
      if @model.get 'isPlaying'
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
      Tuneiversal.activeSong = null
      @$el.removeClass 'playing'
      @swap_play_image()


  swap_play_image: () ->
    if @model.get('isPlaying')#@$el.hasClass 'playing'
      @$el.find('.play-pause').attr('src','/assets/audio_pause.png')
    else
      @$el.find('.play-pause').attr('src','/assets/audio_play.png')

  load_playlist_select: () ->
    allPlaylists = new Tuneiversal.Collections.Playlists
    allPlaylists.fetch success: =>
      @$el.find('.playlist-dropdown-menu').empty()
      for playlist in allPlaylists.models
        @$el.find('.playlist-dropdown-menu').append "<li><a tabindex='-1' class='add-to-playlist' data-playlist='#{playlist.id}'>#{playlist.attributes.title}</a></li>"

  add_song_to_playlist: (ev) ->
    playlist_id = $(ev.target).data('playlist')
    @song = @allSongs.findWhere service: @model.attributes.service, song_id: @model.attributes.song_id
    @songs_ready.done =>
      if not @song == undefined
        $.get("/api/add_song_to_playlist/#{playlist_id}/#{@song.id}")
      else
        waiting_id = new $.Deferred()
        @model.save {}, success: () ->
          waiting_id.resolve()
        waiting_id.done () =>
          $.get("/api/add_song_to_playlist/#{playlist_id}/#{@model.id}")

  onRender: () ->
    if @model.get('isPlaying')
      @swap_play_image()




