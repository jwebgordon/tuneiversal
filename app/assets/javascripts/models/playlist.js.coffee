class Tuneiversal.Models.Playlist extends Backbone.Model
  url: ->
    u = '/playlists.json'
    u = "playlists/#{@id}" if @id
    u
  paramRoot: 'playlist'

  toJSON: () ->
    playlist: _.clone @attributes