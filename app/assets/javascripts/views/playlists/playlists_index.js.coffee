class Tuneiversal.Views.PlaylistsIndex extends Backbone.View
  el: '#app'
  template: JST['playlists/index']

  initialize: ->
    @collection.bind 'reset', @render, @
    @render()

  render: ->
    $(@el).html @template

