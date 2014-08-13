class Tuneiversal.Views.Layouts.RdioSong extends Backbone.Marionette.ItemView
  template: 'layouts/rdio_song'

  events:
    'click .play-pause': 'new_play'
    'click .stop': 'stop'
    'click .add-to-playlist': 'add_song_to_playlist'
    'click .next': 'next'

  initialize: () ->
    # @model.bind('change', @render)
    @model.view = @
    R.ready (ready) =>
      @load_playlist_select()
      R.player.on 'change:playState', @handle_playstate
    @songs_ready = new $.Deferred()
    @allSongs = new Tuneiversal.Collections.Songs
    @allSongs.fetch success: =>
      @songs_ready.resolve()
    
  new_play: () ->
    Tuneiversal.layouts.player.new_play @model

  play_pause: () ->
    if R.player.playState() == R.player.PLAYSTATE_PAUSED or R.player.playState() == R.player.PLAYSTATE_STOPPED
      R.player.play
        source: @model.attributes.song_id
      @set_play_icon true
      @model.set 
        isPlaying: true
    else
      if R.player.playingTrack().attributes.key != @model.attributes.song_id
        console.log 'other song playing'
        R.player.play
          source: @model.attributes.song_id
        @model.set 
          isPlaying: true
        @set_play_icon true
      else if R.player.playingTrack().attributes.key == @model.attributes.song_id
        R.player.togglePause()
        @model.set
          isPlaying: false
        @set_play_icon false

  set_play_icon: (isPlaying) ->
    $('.playing .play-pause').attr('src','/assets/audio_play.png')
    if isPlaying
      console.log 'model playing'
      @$el.find('.play-pause').attr('src','/assets/audio_pause.png')
      @$el.addClass('playing')
    else
      console.log 'model not playing'
      @$el.find('.play-pause').attr('src','/assets/audio_play.png')
      @$el.removeClass('playing')

  handle_playstate: () ->
    if @current_playstate != R.player.playState()
      console.log "Changing playstate: #{R.player.playState()}"
      if R.player.playState() == R.player.PLAYSTATE_PAUSED
      else if R.player.playState() == R.player.PLAYSTATE_PLAYING
      else if R.player.playState() == R.player.PLAYSTATE_STOPPED and @current_playstate == R.player.PLAYSTATE_PLAYING
        console.log 'new playstate stopped'
        Tuneiversal.layouts.player.next()
    @current_playstate = R.player.playState()
    

  stop: () ->
    if R.player.playState() > 0
      @set_play_icon false
      R.player.previous()
      R.player.pause()
      
  next: () ->
    console.log 'next called'
    Tuneiversal.layouts.player.next()
    
    
      
  load_playlist_select: () ->
    allPlaylists = new Tuneiversal.Collections.Playlists
    allPlaylists.fetch success: =>
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
      @set_play_icon true