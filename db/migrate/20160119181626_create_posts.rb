class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :detail
      t.string :attachment
      t.string :topic
      t.boolean :isDeleted
      t.string  :forSale
      t.string   :bookexpected
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
