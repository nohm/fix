class StocksController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, Stock, :message => I18n.t('global.unauthorized')

    @stocks = Stock.where(type_id: params[:type_id])
    @type = Type.find(params[:type_id])
  end

  def new
    authorize! :new, Stock, :message => I18n.t('global.unauthorized')

    @stock = Stock.new
  end

  def create
    authorize! :create, Stock, :message => I18n.t('global.unauthorized')

    params[:stock][:type_id] = params[:type_id]

    @stock = Stock.new(params[:stock].permit(:type_id,:name,:amount,:amount_per_app,:minimum,:send_mail))
    if @stock.save
      redirect_to company_type_stocks_path(params[:company_id], params[:type_id]), :notice => I18n.t('stock.controller.stock_added')
    else
      render 'new'
    end
  end

  def edit
    authorize! :edit, Stock, :message => I18n.t('global.unauthorized')

    @stock = Stock.find(params[:id])
  end

  def update
    authorize! :update, Stock, :message => I18n.t('global.unauthorized')

    @stock = Stock.find(params[:id])

    params[:stock][:type_id] = params[:type_id]
    if @stock.update(params[:stock].permit(:type_id,:name,:amount,:amount_per_app,:minimum,:send_mail))
      redirect_to company_type_stocks_path(params[:company_id], params[:type_id]), :notice => I18n.t('stock.controller.stock_updated')
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, Stock, :message => I18n.t('global.unauthorized')

    stock = Stock.find(params[:id])
    stock.destroy
    redirect_to company_type_stocks_path(params[:company_id], params[:type_id]), :notice => I18n.t('stock.controller.stock_deleted')
  end
end
