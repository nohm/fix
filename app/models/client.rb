class Client < ActiveRecord::Base
	has_many :repairs

	validates :name, presence: true
	
	validates :postal_code, presence: true
	validates :house_number, presence: true
	validates :street, presence: true
	validates :city, presence: true

	before_save :format_input

	private
	    def format_input
	    	self.name = self.name.titleize
	    	self.postal_code.upcase!
	    	self.house_number.upcase!
	    	self.street = self.street.titleize
	    	self.city = self.city.titleize
    	end
end
