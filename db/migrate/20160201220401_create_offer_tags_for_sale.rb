class CreateOfferTagsForSale < ActiveRecord::Migration
  def change
    create_table :Offer_Tag_For_Sales do |t|
      t.string :name
      t.integer :count

      t.timestamps null: false
    end
  end
end
