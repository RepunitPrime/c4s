class CreateOfferTagForExchanges < ActiveRecord::Migration
  def change
    create_table :offer_tag_for_exchanges do |t|
      t.string :name
      t.integer :count

      t.timestamps null: false
    end
  end
end
