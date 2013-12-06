class Tuneiversal.Views.Unauthenticated.Login extends Backbone.Marionette.ItemView
  template: 'unauthenticated/login'
  events:
    'submit form#login-form': 'login'

  initialize: ->
    @model = new Tuneiversal.Models.UserSession()
    @modelBinder = new Backbone.ModelBinder()

  onRender: ->
    @modelBinder.bind(@model, @el)

  login: (e) ->
    el = $(@el)
    e.preventDefault()

    el.find('.login-submit')
    .button 'loading'
    @model.save @model.attributes,
      success: (userSession, response) ->
        el.find('.login-submit')
        .button 'reset'
        Tuneiversal.currentUser = new Tuneiversal.Models.User(response)
        console.log 'logged in'
        Tuneiversal.vent.trigger "authentication:logged_in"
      error: (userSession, response) ->
        result = $.parseJSON response.responseText
        el.find('form')
        .prepend "<div class=\"alert-error\">#{result.error}</div>"
        el.find('.login-submit')
        .button 'reset'
