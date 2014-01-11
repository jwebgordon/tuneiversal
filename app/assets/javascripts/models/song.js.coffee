class Tuneiversal.Models.Song extends Backbone.Model
  url: ->
    u = '/songs.json'
    u = "songs/#{@id}" if @id
    u
  paramRoot: 'song'

  defaults:
    song_id: ''
    title: ''
    artist: ''
    song_url: ''
    author: ''
    isPlaying: false
    track_obj: null

  toJSON: () ->
    song: _.clone @attributes
