class StatsController < ApplicationController
	def index
		authorize! :index, Stats, :message => 'You\'re not authorized for this.'

		# check if company is set
	    unless params[:company].nil?
	      session[:company] = params[:company]
	    end
	    if session[:company].nil?
	      redirect_to root_path, :alert => "You\'re not authorized for this."
	    end

		# Set it up
		entry_stats = Hash.new # brand and type sorted statuses
		entry_stats_global = Array.new # global statuses
		entry_stats_status = Hash.new # test/repair/scrap statuses
		entry_stats_status_global = Array.new # test/repair/scrap global statuses
		(0..6).each do |i| #0..'amount of statuses'
			entry_stats_global[i] = 0
		end
		(0..2).each do |i| #0..'amount of statuses'
			entry_stats_status_global[i] = 0
		end
		entries = Entry.where(company: session[:company])

		# Process entry status codes
		entries.each do |entry|
			# unknown brand
			unless entry_stats.has_key? entry.brand
				entry_stats[entry.brand] = Hash.new
				entry_stats_status[entry.brand] = Hash.new
			end
			# unknown type
			unless entry_stats[entry.brand].has_key? entry.typenum
				entry_stats[entry.brand][entry.typenum] = Array.new
				entry_stats_status[entry.brand][entry.typenum] = Array.new
				(0..6).each do |i| #0..'amount of statuses'
					entry_stats[entry.brand][entry.typenum][i] = 0
				end
				(0..2).each do |i| #0..'amount of statuses'
					entry_stats_status[entry.brand][entry.typenum][i] = 0
				end
			end

			entry_status = Stats.new.process_status(entry)
			entry_stats[entry.brand][entry.typenum][entry_status] = entry_stats[entry.brand][entry.typenum][entry_status] + 1
			entry_stats_global[entry_status] = entry_stats_global[entry_status] + 1

			if entry.scrap == 1
				entry_stats_status[entry.brand][entry.typenum][2] = entry_stats_status[entry.brand][entry.typenum][2] + 1
				entry_stats_status_global[2] = entry_stats_status_global[2] + 1
			elsif entry.repaired == 1
				entry_stats_status[entry.brand][entry.typenum][1] = entry_stats_status[entry.brand][entry.typenum][1] + 1
				entry_stats_status_global[1] = entry_stats_status_global[1] + 1
			elsif (entry.test == 1 or (!entry.defect.nil? and entry.defect.length != 0))
				entry_stats_status[entry.brand][entry.typenum][0] = entry_stats_status[entry.brand][entry.typenum][0] + 1
				entry_stats_status_global[0] = entry_stats_status_global[0] + 1
			end
		end

		# Generate chart data
		@charts = Hash.new
		@charts[:global] = Array.new
		@charts[:global].append Stats.new.generate_chart(session[:company], entries.length.to_s, entry_stats_global, params[:type]) # global chart first
		@charts[:global].append Stats.new.generate_chart_status(session[:company], entries.length.to_s, entry_stats_status_global, params[:type]) # global chart first
		entry_stats.each_pair do |brand, brand_data|
			brand_data.each_pair do |type, type_data|
				type_total = 0
				type_data.each do |i|
					type_total += i
				end
				unless @charts.has_key? (brand + '_' + type.gsub(' ', '_'))
					@charts[brand + '_'  + type.gsub(' ', '_')] = Array.new
				end
			    @charts[brand + '_'  + type.gsub(' ', '_')].append Stats.new.generate_chart(brand + ' ' + type, type_total.to_s, type_data, params[:type]) # each brand and type sorted chart after
			end
		end
		entry_stats_status.each_pair do |brand, brand_data|
			brand_data.each_pair do |type, type_data|
				unless ((type_data[0] + type_data[1] + type_data[2]) == 0)
					type_total = 0
					type_data.each do |i|
						type_total += i
					end
			    	@charts[brand + '_'  + type.gsub(' ', '_')].append Stats.new.generate_chart_status(brand + ' ' + type, type_total.to_s, type_data, params[:type]) # each brand and type sorted chart after
				else
					if params[:type] == 'extended'
						@charts[brand + '_'  + type.gsub(' ', '_')].append LazyHighCharts::HighChart.new('pie')
					else
						@charts[brand + '_'  + type.gsub(' ', '_')].append ''
					end
				end
			end
		end
	end
end
