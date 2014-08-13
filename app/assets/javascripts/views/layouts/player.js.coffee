class Tuneiversal.Views.Layouts.Player extends Backbone.Marionette.CollectionView
    template: 'layouts/player'
    
    initialize: () ->
        @queue = new Tuneiversal.Collections.Songs
        @current_song = null

    new_play: (song) ->
        # FIND SONG IN @QUEUE
        if @current_song? and @current_song.get 'isPlaying'
            @current_song.view.stop()
        if @queue.contains song
            song.view.play_pause()
            @current_song = song
        else
            @queue.add song, {at: 0}
            song.view.play_pause
            @current_song = song

    next: ->
        if @queue.at(@queue.indexOf(@current_song)+1)?
            @current_song.view.stop()
            @current_song = @queue.at @queue.indexOf(@current_song)+1
            @current_song.view.play_pause()
        else
            Messenger().post 
                type: 'error' 
                message: 'No next track'


Tuneiversal.addInitializer () ->
    Tuneiversal.layouts.player = new Tuneiversal.Views.Layouts.Player
