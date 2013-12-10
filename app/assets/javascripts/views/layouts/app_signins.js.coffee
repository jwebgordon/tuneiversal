class Tuneiversal.Views.Layouts.AppSignins extends Backbone.Marionette.Layout
  template: 'layouts/app_signins'

  events:
    'click #soundcloud_signin': 'soundcloud_auth'
    'click #rdio_signin': 'rdio_auth'

  initialize: () ->
    R.ready (ready) ->
      if R.authenticated()
        $('#rdio_signin .sign-in-icon').removeClass('signed-out')
        Tuneiversal.layouts.content_tabs.rdio.show Tuneiversal.layouts.rdio_tab
        Tuneiversal.layouts.rdio_tab.get_user_collection()
      

    
  soundcloud_auto_auth: () ->
    if Tuneiversal.currentUser? and Tuneiversal.currentUser.attributes.has_connected_soundcloud
      promise = new $.Deferred()
      SC.initialize 
        client_id: '0f8a3ab92bb2f82f2ad7e826bbc073da'
        client_secret: '417ecd4081ca6b103dc403cca2e29a61'
        redirect_uri: 'http://localhost:1122'
        access_token: Tuneiversal.currentUser.attributes.sc_access_token
      promise.resolve()
      promise.done () =>
        console.log 'in promise'
        $('#soundcloud_signin .sign-in-icon').removeClass('signed-out')
        Tuneiversal.layouts.content_tabs.soundcloud.show Tuneiversal.layouts.soundcloud_tab
        Tuneiversal.layouts.soundcloud_tab.get_favorites()
    else
      $('#soundcloud_signin .sign-in-icon').addClass('signed-out')
  soundcloud_auth: () ->
    SC.initialize 
      client_id: '0f8a3ab92bb2f82f2ad7e826bbc073da'
      client_secret: '417ecd4081ca6b103dc403cca2e29a61'
      redirect_uri: 'http://localhost:1122'
      access_token: Tuneiversal.currentUser.attributes.sc_access_token
    if SC.isConnected()
      Tuneiversal.currentUser.save(has_connected_soundcloud: true)
      $('#soundcloud_signin .sign-in-icon').removeClass('signed-out')
      Tuneiversal.layouts.content_tabs.soundcloud.show Tuneiversal.layouts.soundcloud_tab
      Tuneiversal.layouts.soundcloud_tab.get_favorites()
    else
      SC.connect () ->
        Tuneiversal.currentUser.save(has_connected_soundcloud: true, sc_access_token: SC.accessToken())
        $('#soundcloud_signin .sign-in-icon').removeClass('signed-out')
    
    # SC.connect () ->
    #   SC.get '/me', (me) ->

  rdio_auth: () ->
    R.authenticate (authenticated) ->
      if authenticated
        $('#rdio_signin .sign-in-icon').removeClass('signed-out')



Tuneiversal.addInitializer () ->
  Tuneiversal.layouts.app_signins = new Tuneiversal.Views.Layouts.AppSignins