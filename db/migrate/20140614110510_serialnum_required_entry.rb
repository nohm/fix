class SerialnumRequiredEntry < ActiveRecord::Migration
  def change
  	add_column :entries, :serialnum_required, :integer
  end
end
