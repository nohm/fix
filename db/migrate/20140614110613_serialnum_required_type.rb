class SerialnumRequiredType < ActiveRecord::Migration
  def change
  	remove_column :entries, :serialnum_required
  	add_column :apptypes, :serialnum_required, :integer
  end
end
