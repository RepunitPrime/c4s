class CreateOfferComments < ActiveRecord::Migration
  def change
    create_table :offer_comments do |t|
      t.text :comment_body
      t.references :user, index:true, foreign_key:true
      t.references :offer, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
