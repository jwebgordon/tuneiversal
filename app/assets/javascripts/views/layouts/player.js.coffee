class Tuneiversal.Views.Layouts.Player extends Backbone.Marionette.CollectionView
    template: 'layouts/player'
    
    initialize: () ->
        @queue = new Tuneiversal.Collections.Songs
        @current_song = null

    new_play: (song) ->
        # FIND SONG IN @QUEUE
        if song in @queue
            song.view.play_pause()
            @current_song = song
        else
            @queue.add song
            song.view.play_pause
            @current_song = song



Tuneiversal.addInitializer () ->
    # Tuneiversal.layouts.player = new Tuneiversal.Views.Layouts.Player
