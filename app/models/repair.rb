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
end
