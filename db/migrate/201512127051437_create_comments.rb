# DB Migrate Script to Create Comments Table
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :username
      t.text :comment_body
      t.references :article, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
