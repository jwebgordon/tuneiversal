class PlaylistSerializer < ActiveModel::Serializer
	attributes :id, :title, :song_count, :songs

	# has_many :songs, serializer: SongSerializer,
	# 	embed: :ids, include: true, key: :songs
end