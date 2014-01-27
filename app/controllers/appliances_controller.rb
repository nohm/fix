class AppliancesController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Appliance, :message => I18n.t('global.unauthorized')

    @appliance = Appliance.new
  end

  def index
    authorize! :index, Appliance, :message => I18n.t('global.unauthorized')

    @appliances = Appliance.all.page(params[:page]).per(25)
  end

  def create
    authorize! :create, Appliance, :message => I18n.t('global.unauthorized')

    @appliance = Appliance.new(params[:appliance].permit(:name,:abb,:preview))

    if @appliance.save
      redirect_to appliances_path, :notice => I18n.t('appliance.controller.notice_added')
    else
      render 'new'
    end
  end
  
end
