class AddTagsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :Tags, :string
    add_column :articles, :tags_search, :string
  end
end
