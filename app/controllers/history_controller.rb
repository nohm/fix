class HistoryController < ApplicationController
    before_filter :authenticate_user!

	def index
		authorize! :index, History, :message => I18n.t('global.unauthorized')

		@entries = Entry.all
    	@appliances = Appliance.all
		@history = History.all.page(params[:page]).per(25)
		@users = User.all
	end
end
