class Repair < ActiveRecord::Base
	belongs_to :client

	validates :status_id, presence: true
	validates :brand, presence: true
	validates :type_number, presence: true
	validates :serial_number, presence: true
	validates :warranty, presence: true
	validates :sales_receipt, presence: true
	validates :method_acquire, presence: true
	validates :method_return, presence: true
	validates :priority, presence: true
	validates :client_id, presence: true

	before_save :format_input

	def number
		"#{ENV['NUMBER_PREFIX']}#{self.id}"
	end

	def self.process_status
		1 # 'TODO'
	end

	def get_status
		Repair.statuses[self.status_id - 1]
	end

	def self.statuses
		['TODO']
	end

	def acquire_methods
		YAML.load(ENV['ACQUIRES'])
	end

	def priorities
		YAML.load(ENV['PRIOS'])
	end

	def get_barcode
	    require 'barby'
	    require 'barby/barcode/code_39'
	    require 'barby/outputter/svg_outputter'

	    barcode = Barby::Code39.new("#{self.number}")
	    barcode.to_svg(height: 60, xdim: 3)
	end

	private
	    def format_input
	    	self.brand = self.brand.titleize
	    	self.type_number.upcase!
      		self.serial_number.upcase!
    	end
end
