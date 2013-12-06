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

  # relations: [
  #   type: Backbone.HasMany
  #   key: 'playlists'
  #   relatedModel: Tuneiversal.Models.Playlist
  #   collectionType: Tuneiversal.Collections.Playlists
  #   reverseRelation: 
  #     key: 'songs'
  #     includeInJSON: 'id'
  #   ]
  toJSON: () ->
    song: _.clone @attributes
