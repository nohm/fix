class Company < ActiveRecord::Base
	has_many :entries, dependent: :destroy
	has_many :invoices, dependent: :destroy
	has_many :types, dependent: :destroy

	validates :title, presence: true
  	validates :short, presence: true
  	validates :abb, presence: true
  	validates :address, presence: true
end
