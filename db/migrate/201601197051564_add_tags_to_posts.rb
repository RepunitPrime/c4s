class AddTagsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :tags, :string
    add_column :posts, :tags_search, :string
  end
end
