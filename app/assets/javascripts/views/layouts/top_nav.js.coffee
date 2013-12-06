class Tuneiversal.Views.Layouts.TopNav extends Backbone.Marionette.Layout
  template: 'layouts/top_nav'
  events:
    'click #signout-button': 'signout'

  signout: () ->
    $.ajax
      method: 'DELETE'
      url: '/users/sign_out'
    .done window.location.reload()
    


Tuneiversal.addInitializer () ->
  Tuneiversal.layouts.top_nav = new Tuneiversal.Views.Layouts.TopNav