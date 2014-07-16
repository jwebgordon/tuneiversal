class Tuneiversal.Views.Layouts.Song extends Backbone.Marionette.ItemView
    template: 'layouts/sc_song'

    # events:

    initialize: () ->
        @model.view = @
        @songs_ready = new $.Deferred()
        @allSongs = new Tuneiversal.Collections.Songs
        @allSongs.fetch success: =>
            @songs_ready.resolve()
        
    load_playlist_select: () ->
        allPlaylists = new Tuneiversal.Collections.Playlists
        allPlaylists.fetch success: =>
            @$el.find('.playlist-dropdown-menu').empty()
            for playlist in allPlaylists.models
                @$el.find('.playlist-dropdown-menu').append "<li><a tabindex='-1' class='add-to-playlist' data-playlist='#{playlist.id}'>#{playlist.attributes.title}</a></li>"
