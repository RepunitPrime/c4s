# This migrate script is used to add a profile pic to the users table using PaperClip method
class AddProfilePicToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :users, :profile_pic
  end

  def self.down
    remove_attachment :users, :profile_pic
  end
end
