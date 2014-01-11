window.Tuneiversal = new Backbone.Marionette.Application()

Backbone.Marionette.Renderer.render = (template, data) ->
  if !JST[template] 
    throw "Template '" + template + "' not found!"
  return JST[template](data)

Tuneiversal.Models = {}
Tuneiversal.Collections = {}
Tuneiversal.Views = {}
Tuneiversal.Views.Layouts = {}
Tuneiversal.Views.Unauthenticated = Tuneiversal.Views.Unauthenticated || {}
Tuneiversal.Routers = {}
Tuneiversal.layouts = {}
Tuneiversal.addRegions
  app: '#app'
Tuneiversal.vent.on 'authentication:logged_in', () ->
  Tuneiversal.app.show Tuneiversal.layouts.main
  Tuneiversal.layouts.main.sign_ins.show Tuneiversal.layouts.app_signins
  Tuneiversal.layouts.app_signins.soundcloud_auto_auth()
  Tuneiversal.layouts.main.nav.show Tuneiversal.layouts.top_nav
  Tuneiversal.layouts.main.content.show Tuneiversal.layouts.content_tabs
  Tuneiversal.layouts.content_tabs.playlists.show Tuneiversal.layouts.playlists_tab
  console.log 'assigning env'
  if window.location.href.indexOf 'local' >= 0
    Tuneiversal.env = "DEV"
  else
    Tuneiversal.env = "PROD"
  Messenger.options = 
    theme: 'block'
    extraClasses: 'messenger-fixed messenger-on-top'
  Backbone.history.start()
Tuneiversal.vent.on 'authentication:logged_out', () ->
  console.log 'logged out'
  Tuneiversal.app.show Tuneiversal.layouts.auth_base
Tuneiversal.bind 'initialize:after', () ->
  if Tuneiversal.currentUser
    Tuneiversal.vent.trigger 'authentication:logged_in'
  else
    Tuneiversal.vent.trigger 'authentication:logged_out'


  
