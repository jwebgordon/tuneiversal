class Tuneiversal.Models.UserRegistration extends Backbone.Model
  url: '/users.json'
  paramRoot: 'user'
  defaults: 
    email: "",
    password: "",
    password_confirmation: ""

  toJSON: () ->
    return { user: _.clone(@attributes) }

    