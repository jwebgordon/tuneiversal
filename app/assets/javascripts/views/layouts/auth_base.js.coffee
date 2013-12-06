class Tuneiversal.Views.Layouts.AuthBase extends Backbone.Marionette.Layout
  template: 'layouts/auth_base'
  regions:
    content: '.tab-content'

  views: {}

  events: 
    'click ul.nav-tabs li a': 'switchViews'

  onShow: () ->
    @views.login = Tuneiversal.Views.Unauthenticated.Login
    @views.signup = Tuneiversal.Views.Unauthenticated.Signup
    @views.retrievePassword = Tuneiversal.Views.Unauthenticated.RetrievePassword
    @content.show new @views.login

  switchViews: (e) ->
    e.preventDefault()
    console.log e.target
    @content.show new @views[$(e.target).attr('data-content')]
  # render: () ->
  #   console.log "render called #{@template}"
  #   $('#app').html @template


Tuneiversal.addInitializer () ->
  console.log 'adding auth layout'
  Tuneiversal.layouts.auth_base = new Tuneiversal.Views.Layouts.AuthBase