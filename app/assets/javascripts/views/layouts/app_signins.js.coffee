class Tuneiversal.Views.Layouts.AppSignins extends Backbone.Marionette.Layout
  template: 'layouts/app_signins'

  events:
    'click #soundcloud_signin': 'soundcloud_auth'
    'click #rdio_signin': 'rdio_auth'

  initialize: () ->
    R.ready (ready) =>
      if Tuneiversal.env == "DEV"
        @sc_redirect_uri = 'http://localhost:1122'
        @sc_client_id = 'b6ac35d3e02f6b58d23d66920cba49a6'
        @sc_client_secret = '7c5e0477aa49924c08e9d8e6a9e463a3'
      else
        @sc_redirect_uri = 'http://app.tuneiversal.com'
        @sc_client_id = '0f8a3ab92bb2f82f2ad7e826bbc073da'
        @sc_client_secret = '417ecd4081ca6b103dc403cca2e29a61'
      if R.authenticated()
        $('#rdio_signin .sign-in-icon').removeClass('signed-out')
        Tuneiversal.layouts.content_tabs.rdio.show Tuneiversal.layouts.rdio_tab
        Tuneiversal.layouts.rdio_tab.get_user_collection()
      

    
  soundcloud_auto_auth: () ->
    if Tuneiversal.currentUser? and Tuneiversal.currentUser.attributes.has_connected_soundcloud
      promise = new $.Deferred()
      SC.initialize 
        client_id: @sc_client_id
        client_secret: @sc_client_secret
        redirect_uri: @sc_redirect_uri
        access_token: Tuneiversal.currentUser.attributes.sc_access_token
      promise.resolve()
      promise.done () =>
        $('#soundcloud_signin .sign-in-icon').removeClass('signed-out')
        Tuneiversal.layouts.content_tabs.soundcloud.show Tuneiversal.layouts.soundcloud_tab
        Tuneiversal.layouts.soundcloud_tab.get_favorites()
    else
      $('#soundcloud_signin .sign-in-icon').addClass('signed-out')
  soundcloud_auth: () ->
    SC.initialize 
      client_id: @sc_client_id
      client_secret: @sc_client_secret
      redirect_uri: @sc_redirect_uri
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

  rdio_auth: () ->
    R.authenticate (authenticated) ->
      if authenticated
        $('#rdio_signin .sign-in-icon').removeClass('signed-out')



Tuneiversal.addInitializer () ->
  Tuneiversal.layouts.app_signins = new Tuneiversal.Views.Layouts.AppSignins