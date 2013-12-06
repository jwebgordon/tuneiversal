class Tuneiversal.Views.Unauthenticated.Signup extends Backbone.Marionette.ItemView
  template: 'unauthenticated/signup'

  events:
    'submit form#signup-form': 'signup'

  initialize: () ->
    @model = new Tuneiversal.Models.UserRegistration
    @modelBinder = new Backbone.ModelBinder

  onRender: () ->
    @modelBinder.bind @model, @el
    console.log @el

  signup: (e) ->
    el = $(@el)
    e.preventDefault()

    el.find('.signup-submit')
    .button 'loading'
    el.find('.alert-error')
    .remove()
    el.find('.help-block')
    .remove()
    el.find('.control-group.error')
    .removeClass 'error'

    @model.save @model.attributes,
      success: (userSession, response) ->
        el.find('.signup-submit')
        .button 'reset'
        Tuneiversal.currentUser = new Tuneiversal.Models.User(response)
        Tuneiversal.vent.trigger 'authentication:logged_in'
      error: (userSession, response) ->
        result = $.parseJSON response.responseText
        el.find('form')
        .prepend '<div class="alert-error">Unable to complete signup</div>'
        _(result.errors).each (errors,field) ->
          $('#'+field+'_group').addClass('error')
          _(errors).each (error, i) ->
            $('#'+field+'_group .controls').append("ERROR")
        el.find('.signup-submit')
        .button 'reset'