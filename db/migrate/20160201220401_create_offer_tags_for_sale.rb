class CreateOfferTagsForSale < ActiveRecord::Migration
  def change
    create_table :Offer_Tags_For_Sale do |t|
      t.string :name
      t.integer :count

      t.timestamps null: false
    end
  end
end
