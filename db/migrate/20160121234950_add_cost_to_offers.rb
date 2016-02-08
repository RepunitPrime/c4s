class AddCostToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :cost, :string
  end
end
