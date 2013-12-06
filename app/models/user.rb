class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :id, :created_at, :updated_at, :has_connected_soundcloud, :sc_access_token

  has_many :playlists
  has_many :songs

  def update_with_password(params={})
  	if params[:password].blank?
  		params.delete(:password)
  		params.delete(:password_confirmation) if params[:password_confirmation].blank?
  	end
  	update_attributes(params)
  end
end
