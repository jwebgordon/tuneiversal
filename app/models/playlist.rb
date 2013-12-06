class Playlist < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :songs
	attr_accessible :title
end
