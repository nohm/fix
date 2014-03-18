class Shipment < ActiveRecord::Base
	belongs_to :company

	has_many :entries

	validates :number, presence: true
  	validates :expectance, presence: true
end
