class StatsController < ApplicationController
	def index
		# Set it up
		@entry_stats = Array.new
		(0..6).each do |i|
			@entry_stats[i] = 0
		end
		@entries = Entry.where(company: session[:company])

		# Process entry status codes
		@entries.each do |entry|
			processed = 0

		    if entry.sent == 1
				@entry_stats[6] = @entry_stats[6] + 1
				processed = 1
		    end

		    if entry.ready == 1 and processed == 0
				@entry_stats[5] = @entry_stats[5] + 1
				processed = 1
		    end

		    if entry.accessoires == 1 and processed == 0
				@entry_stats[4] = @entry_stats[4] + 1
				processed = 1
		    end

		    if entry.scrap == 1 and processed == 0
				@entry_stats[3] = @entry_stats[3] + 1
				processed = 1
		    end

		    if entry.repaired == 1 and processed == 0
			  	@entry_stats[2] = @entry_stats[2] + 1
				processed = 1
		    end

		    if (entry.test == 1 or (!entry.defect.nil? and entry.defect.length != 0)) and processed = 0
		      @entry_stats[1] = @entry_stats[1] + 1
		      processed = 1
		    end

    		unless processed == 1
    			@entry_stats[0] = @entry_stats[0] + 1
    		end
		end

		# Generate chart data
		@chart = LazyHighCharts::HighChart.new('column') do |f|
	      f.chart({ type: 'column', marginRight: 130, marginBottom: 25 })
	      f.title({ text: 'Status for ' + session[:company], x: -20 })
	      f.yAxis({ title: { text: 'Amount' }, plotLines: [{ value: 0, width: 1, color: '#808080' }] })
	      f.xAxis({ categories: ['Status'] })
	      f.legend({ layout: 'vertical', align: 'right', verticalAlign: 'top', x: -10, y: 100, borderWidth: 0 })
	      
	      f.series({ name: 'New', data: [@entry_stats[0].to_f] })
	      f.series({ name: 'Tested', data: [@entry_stats[1].to_f] })
	      f.series({ name: 'Repaired', data: [@entry_stats[2].to_f] })
	      f.series({ name: 'Scrap', data: [@entry_stats[3].to_f] })
	      f.series({ name: 'Waiting', data: [@entry_stats[4].to_f] })
	      f.series({ name: 'Ready', data: [@entry_stats[5].to_f] })
	      f.series({ name: 'Sent', data: [@entry_stats[6].to_f] })
	    end
	end
end
