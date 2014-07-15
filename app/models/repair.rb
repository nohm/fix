class Repair < ActiveRecord::Base
	belongs_to :client

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
