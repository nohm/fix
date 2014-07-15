class HomeController < ApplicationController
  def index
  	statuses = Repair.statuses
  	status_data = Array.new {0}
  	statuses.each_with_index do |status, index|
  		status_data.append(Repair.where(status_id: index + 1).count)
  	end
  	@chart_status = Home.generate_bar_chart(statuses, statuses.length - 1, status_data)

  	priorities = Repair.group(:priority).distinct.count(:priority)
  	@chart_prio = Home.generate_bar_chart(priorities.keys, priorities.length - 1, priorities.values)
  end
end
