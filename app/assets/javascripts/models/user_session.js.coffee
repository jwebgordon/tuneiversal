class Tuneiversal.Models.UserSession extends Backbone.Model
  url: 'users/sign_in.json'
  paramRoot: 'user'
  defaults:
    email: ""
    password: ""

  toJSON: () ->
    user: _.clone @attributes