class IndexToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :company_id, :integer
    add_index :invoices, :company_id
  end
end
