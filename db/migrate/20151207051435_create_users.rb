# DB Migrate Script to Create Users Table
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :name
      t.string   :email
      t.string   :username
      t.string   :encrypted_password
      t.string   :salt
      t.string   :address
      t.timestamps null: false
    end
  end


end
