class Client < ActiveRecord::Base
	has_many :repairs

	validates :name, presence: true
	
	validates :postal_code, presence: true
	validates :house_number, presence: true
	validates :street, presence: true
	validates :city, presence: true
end
