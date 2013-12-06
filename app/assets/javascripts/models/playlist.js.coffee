class Tuneiversal.Models.Playlist extends Backbone.Model
  url: ->
    u = '/playlists.json'
    u = "playlists/#{@id}" if @id
    u
  paramRoot: 'playlist'


  # relations: [
  #   type: Backbone.HasMany
  #   key: 'songs'
  #   relatedModel: Tuneiversal.Models.Song
  #   collectionType: Tuneiversal.Collections.Song
  #   reverseRelation:
  #     key: 'playlists'
  #     includeInJSON: 'id'
  #   ]


  toJSON: () ->
    playlist: _.clone @attributes