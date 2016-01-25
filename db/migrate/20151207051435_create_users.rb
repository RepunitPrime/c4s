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
      t.string   :activation_digest
      t.boolean  :activated
      t.datetime :activated_at
      t.string   :reset_digest
      t.datetime :reset_sent_at
    end
  end


end
