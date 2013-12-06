class Tuneiversal.Models.User extends Backbone.Model
  url: '/users.json'
  paramRoot: 'user'

  toJSON: () ->
    user: _.clone @attributes