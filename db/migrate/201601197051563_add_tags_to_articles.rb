class AddTagsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :Tags, :string
  end
end
