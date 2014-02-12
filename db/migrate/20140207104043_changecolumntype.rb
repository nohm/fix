class Changecolumntype < ActiveRecord::Migration
  def change
  	remove_column :stocks, :send_mail
  	add_column :stocks, :send_mail, :integer
  end
end
