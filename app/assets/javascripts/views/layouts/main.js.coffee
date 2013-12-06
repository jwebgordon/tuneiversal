class Tuneiversal.Views.Layouts.Main extends Backbone.Marionette.Layout
  template: 'layouts/main'

  regions:
    nav: '#top-nav'
    content: '#the-content'
    sign_ins: '#sign-ins'

  initialize: () ->
    


Tuneiversal.addInitializer () ->
  console.log "main layout"
  Tuneiversal.layouts.main = new Tuneiversal.Views.Layouts.Main()