class ApptypesController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    permission = false
    unless current_user.nil? or params[:company_id].nil?
      if current_user.staff? or Company.where(short: current_user.roles.first.name).take.id == params[:company_id].to_i
        permission = true
      end
    end
    unless permission
      redirect_to root_path, :alert => I18n.t('global.unauthorized')
    end
  end

  def index
    authorize! :index, Apptype, :message => I18n.t('global.unauthorized')

    @types = Apptype.where(company_id: params[:company_id]).order('id ASC').page(params[:page]).per(25)
    @company = Company.find(params[:company_id])
    @appliances = Appliance.all.order('id ASC')
  end

  def new
    authorize! :new, Apptype, :message => I18n.t('global.unauthorized')

    @type = Apptype.new
    @appliance_names = Appliance.pluck(:name, :id)
  end

  def create
    authorize! :create, Apptype, :message => I18n.t('global.unauthorized')

    params[:apptype][:company_id] = params[:company_id]

    @type = Apptype.new(params[:apptype].permit(:appliance_id,:brand,:typenum,:test_price,:repair_price,:scrap_price,:company_id))
    if @type.save
      redirect_to company_types_path(params[:company_id]), :notice => I18n.t('type.controller.type_added')
    else
      @appliance_names = Appliance.pluck(:name, :id)
      render 'new'
    end
  end

  def edit
    authorize! :edit, Apptype, :message => I18n.t('global.unauthorized')

    @type = Apptype.find(params[:id])
    @appliance_names = Appliance.pluck(:name, :id)
  end

  def update
    authorize! :update, Apptype, :message => I18n.t('global.unauthorized')

    @type = Apptype.find(params[:id])

    params[:apptype][:company_id] = params[:company_id]
    if @type.update(params[:apptype].permit(:appliance_id,:brand,:typenum,:test_price,:repair_price,:scrap_price,:company_id))
      redirect_to company_types_path(params[:company_id]), :notice => I18n.t('type.controller.type_updated')
    else
      @appliance_names = Appliance.pluck(:name, :id)
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, Apptype, :message => I18n.t('global.unauthorized')

    type = Apptype.find(params[:id])
    Apptype.stocks.destroy
    type.destroy
    redirect_to company_types_path(params[:company_id]), :notice => I18n.t('type.controller.type_deleted')
  end
end
