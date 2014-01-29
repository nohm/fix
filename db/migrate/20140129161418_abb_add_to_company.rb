class AbbAddToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :abb, :string
  	add_column :companies, :adress, :string
  end
end
