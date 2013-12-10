class Tuneiversal.Views.Layouts.PlaylistsTab extends Backbone.Marionette.Layout
  template: 'layouts/playlists_tab'

  initialize: () ->
    # @get_and_render_playlists()

  get_and_render_playlists: () ->
    console.log 'called get_and_render_playlists'
    if Tuneiversal.allPlaylists?
      console.log 'in this if'
      # Add code for rendering new playlists
    else
      @allPlaylists = new Tuneiversal.Collections.Playlists
      @allPlaylists.fetch success: () =>
        console.log @allPlaylists
        for playlist in @allPlaylists.models
          list_view = new Tuneiversal.Views.Layouts.Playlist model: playlist
          console.log @$el
          @$el.find('#playlist-left').append list_view.render().el
        Tuneiversal.allPlaylists = @allPlaylists


Tuneiversal.addInitializer () ->
  Tuneiversal.layouts.playlists_tab = new Tuneiversal.Views.Layouts.PlaylistsTab