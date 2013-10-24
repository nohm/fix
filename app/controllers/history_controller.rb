class HistoryController < ApplicationController
	def index
		@entries = Entry.all
    	@appliances = Appliance.all
		@history = History.all.page(params[:page]).per(25)
		@users = User.all
	end
end
