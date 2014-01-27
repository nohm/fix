class AddImgUrlToAppliances < ActiveRecord::Migration
  def change
  	add_column :appliances, :preview, :string
  end
end
