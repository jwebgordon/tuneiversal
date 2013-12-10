class Tuneiversal.Models.UserRegistration extends Backbone.Model
  url: '/users.json'
  paramRoot: 'user'
  defaults: 
    email: "",
    password: "",
    password_confirmation: ""

  toJSON: () ->
    return { user: _.clone(@attributes) }
  # sync: (method, model, options) ->

  # save: (attributes, options) ->
  #   attributes = attributes || {}
  #   options = options || {}

  #   attributes = 
  #     user: attributes

  #   Backbone.Model.prototype.save(attribut)
    