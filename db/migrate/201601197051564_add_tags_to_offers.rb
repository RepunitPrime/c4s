class AddTagsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :tags, :string
    add_column :offers, :tags_search, :string
  end
end
