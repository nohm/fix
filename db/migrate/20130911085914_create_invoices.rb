class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :items
      t.datetime :date

      t.timestamps
    end
  end
end
