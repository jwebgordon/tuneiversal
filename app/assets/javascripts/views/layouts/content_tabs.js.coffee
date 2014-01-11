class Tuneiversal.Views.Layouts.ContentTabs extends Backbone.Marionette.Layout
  template: 'layouts/content_tabs'

  regions:
    'soundcloud': '#soundcloud'
    'rdio': '#rdio'
    'playlists': '#playlists'

  events:
    'click a[href="#playlists"]': 'init_playlists'

  init_playlists: () -> 
    Tuneiversal.layouts.playlists_tab.get_and_render_playlists()



Tuneiversal.addInitializer () ->
  Tuneiversal.layouts.content_tabs = new Tuneiversal.Views.Layouts.ContentTabs