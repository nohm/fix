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

  def update
    authorize! :update, Appliance, :message => I18n.t('global.unauthorized')

    appliance = Appliance.find(params[:id])
    if appliance.update(params[:appliance].permit(:preview))
      redirect_to appliances_path, :notice => I18n.t('notice_updated')
    else
      redirect_to appliances_path, :alert => I18n.t('notice_update_fail')
    end
  end

  # Only destroys attachment
  def destroy
    authorize! :update, Appliance, :message => I18n.t('global.unauthorized')

    appliance = Appliance.find(params[:id])
    appliance.preview = nil
    if appliance.save
      redirect_to appliances_path, :notice => I18n.t('notice_deleted')
    else
      redirect_to appliances_path, :alert => I18n.t('notice_delete_fail')
    end
  end
  
end
