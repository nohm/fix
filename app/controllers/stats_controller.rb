class StatsController < ApplicationController
	def index

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
		(0..6).each do |i| #0..'amount of statuses'
			entry_stats_global[i] = 0
		end
		entries = Entry.where(company: session[:company])

		# Process entry status codes
		entries.each do |entry|
			# unknown brand
			unless entry_stats.has_key? entry.brand
				entry_stats[entry.brand] = Hash.new
			end
			# unknown type
			unless entry_stats[entry.brand].has_key? entry.typenum
				entry_stats[entry.brand][entry.typenum] = Array.new
				(0..6).each do |i| #0..'amount of statuses'
					entry_stats[entry.brand][entry.typenum][i] = 0
				end
			end

			entry_status = Stats.new.process_status(entry)
			entry_stats[entry.brand][entry.typenum][entry_status] = entry_stats[entry.brand][entry.typenum][entry_status] + 1
			entry_stats_global[entry_status] = entry_stats_global[entry_status] + 1
		end

		# Generate chart data
		@charts = Array.new
		@charts.append Stats.new.generate_chart(session[:company], entries.length.to_s, entry_stats_global) # global chart first
		entry_stats.each_pair do |brand, brand_data|
			brand_data.each_pair do |type, type_data|
				type_total = 0
				type_data.each do |i|
					type_total += i
				end
			    @charts.append Stats.new.generate_chart(brand + ' ' + type, type_total.to_s, type_data) # each brand and type sorted chart after
			end
		end
	end
end
