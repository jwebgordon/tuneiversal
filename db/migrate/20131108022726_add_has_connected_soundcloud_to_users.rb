class AddHasConnectedSoundcloudToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_connected_soundcloud, :boolean
  end
end
