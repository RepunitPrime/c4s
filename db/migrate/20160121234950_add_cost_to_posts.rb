class AddCostToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :cost, :string
  end
end
