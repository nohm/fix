class Stock < ActiveRecord::Base
	has_and_belongs_to_many :apptype

  validates :company_id, presence: true
  validates :name, presence: true
  validates :amount, presence: true
  validates :amount_per_app, presence: true
  validates :minimum, presence: true
  validates :send_mail, presence: true

  def update_stock(entry)
    stocks = entry.apptype.stocks
    stocks.each do |stock|
      diff = 0

      unless entry.status.nil? or entry.status.start_with? 'Sent' or entry.get_status.start_with? 'Sent'
        if entry.status != 'Ready' and entry.get_status == 'Ready'
          diff = -stock.amount_per_app
        elsif entry.status == 'Ready' and entry.get_status != 'Ready'
          diff = stock.amount_per_app
        end

        if stock.amount - diff < 0
          diff = -stock.amount
        end

        unless diff == 0
          stock.update_attribute(:amount, stock.amount + diff)

          last_mail = stock.last_mail || Date.yesterday
          if stock.amount <= stock.minimum and stock.send_mail == 1 and last_mail != Date.today
            MailJob.new.async.perform(5, {'type' => stock.type.brand_type.gsub('_',' '), 'stock' => stock.name, 'email' => stock.type.company.mail})
          end
        end
      end
    end
  end

end
