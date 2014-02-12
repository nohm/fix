class Laststockmail < ActiveRecord::Migration
  def change
  	add_column :stocks, :last_mail, :datetime
  end
end
