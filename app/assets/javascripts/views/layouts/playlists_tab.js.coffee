class Tuneiversal.Views.Layouts.PlaylistsTab extends Backbone.Marionette.Layout
  template: 'layouts/playlists_tab'

  events: 
    'click #playlist_create_btn': 'create_playlist'

  initialize: () ->
    # @get_and_render_playlists()

  get_and_render_playlists: () ->
    console.log 'called get_and_render_playlists'
    # if Tuneiversal.allPlaylists?
    #   console.log 'in this if'
    #   # Add code for rendering new playlists
    # else
    @allPlaylists = new Tuneiversal.Collections.Playlists
    @allPlaylists.fetch success: () =>
      console.log @allPlaylists
      @$el.find('#playlist-left').empty()
      for playlist in @allPlaylists.models
        list_view = new Tuneiversal.Views.Layouts.Playlist model: playlist
        console.log @$el
        @$el.find('#playlist-left').append list_view.render().el
      Tuneiversal.allPlaylists = @allPlaylists


  create_playlist: () ->
    if $('#playlist_name').val().length > 0
      playlist = new Tuneiversal.Models.Playlist 
        title: $('#playlist_name').val()
      playlist.save {}, success: () =>
        Messenger().post 'Playlist successfully created'
        @render()
        @get_and_render_playlists()
    else 
      Messenger().post 
        type: 'error' 
        message: 'Please enter a playlist name'


Tuneiversal.addInitializer () ->
  Tuneiversal.layouts.playlists_tab = new Tuneiversal.Views.Layouts.PlaylistsTab