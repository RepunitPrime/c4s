# DB Migrate Script to Create Articles Table
class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text, default: ''
      t.integer :views, default: 0
      t.integer :count_comments, default: 0
      t.references :topic, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
