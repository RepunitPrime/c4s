class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :streetname
      t.integer :streetnumber
      t.string :city
      t.string :country
      t.integer :pincode
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
