class Tuneiversal.Views.Layouts.ContentTabs extends Backbone.Marionette.Layout
  template: 'layouts/content_tabs'

  regions:
    'soundcloud': '#soundcloud'
    'playlists': '#playlists'



Tuneiversal.addInitializer () ->
  Tuneiversal.layouts.content_tabs = new Tuneiversal.Views.Layouts.ContentTabs