class CreateAdComments < ActiveRecord::Migration
  def change
    create_table :ad_comments do |t|
      t.text :comment_body
      t.references :user, index:true, foreign_key:true
      t.references :post, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
