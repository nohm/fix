class StatsController < ApplicationController
	def index
		authorize! :index, Stats, :message => I18n.t('global.unauthorized')

		@company = Company.find(params[:company_id])
		@shipment = Shipment.find(params[:shipment_id])

		type_global_all = Array.new(7) {0}
		type_global_min = Array.new(4) {0}

		@charts = Hash.new
		@charts[:global] = Array.new

		@company.apptypes.each do |type|
			type_all = Array.new(7) {0}
			type_min = Array.new(4) {0}
			type_total_all = 0
			type_total_min = 0

			type_entries = Entry.where(shipment_id: @shipment.id, apptype_id: type.id)
			type_entries.each do |entry|
				if entry.scrap == 1
					s = 2
				elsif entry.repaired == 1
					s = 1
				elsif entry.test == 1 or (!entry.defect.nil? and entry.defect != '')
					s = 0
				else
					s = 3
				end

				type_min[s] += 1
				type_global_min[s] += 1

				status = Stats.new.process_status(entry)
				type_all[status] += 1
				type_global_all[status] += 1
			end

			unless type_entries.length == 0
				@charts[type.brand_type] = Array.new
				@charts[type.brand_type].append Stats.new.generate_chart(type.brand_type.gsub('_',''), type_entries.length, type_all, params[:type])
				unless type_min[0] + type_min[1] + type_min[2] + type_min[3] == 0
					@charts[type.brand_type].append Stats.new.generate_chart_status(type.brand_type.gsub('_',''), type_entries.length, type_min, params[:type])
				else
					if params[:type] == 'extended'
						@charts[type.brand_type].append LazyHighCharts::HighChart.new('pie')
					else
						@charts[type.brand_type].append ''
					end
				end
			end
		end

		@charts[:global].append Stats.new.generate_chart(@company.short, @shipment.entries.length, type_global_all, params[:type])
		@charts[:global].append Stats.new.generate_chart_status(@company.short, @shipment.entries.length, type_global_min, params[:type])
	end
end
