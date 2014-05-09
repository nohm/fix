class StocksController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, Stock, :message => I18n.t('global.unauthorized')

    @stocks = Stock.where(company_id: params[:company_id]).order('id ASC')
    @company = Company.find(params[:company_id])
  end

  def new
    authorize! :new, Stock, :message => I18n.t('global.unauthorized')

    @stock = Stock.new
  end

  def create
    authorize! :create, Stock, :message => I18n.t('global.unauthorized')

    params[:stock][:company_id] = params[:company_id]
    @stock = Stock.new(params[:stock].permit(:company_id,:name,:amount,:amount_per_app,:minimum,:send_mail))
    if @stock.save
      redirect_to company_stocks_path(params[:company_id]), :notice => I18n.t('stock.controller.stock_added')
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

    params[:stock][:company_id] = params[:company_id]
    if @stock.update(params[:stock].permit(:company_id,:name,:amount,:amount_per_app,:minimum,:send_mail))
      redirect_to company_stocks_path(params[:company_id]), :notice => I18n.t('stock.controller.stock_updated')
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, Stock, :message => I18n.t('global.unauthorized')

    stock = Stock.find(params[:id])
    stock.types.destroy
    stock.destroy
    redirect_to company_stocks_path(params[:company_id]), :notice => I18n.t('stock.controller.stock_deleted')
  end

  def type_stock
    authorize! :type_stock, Stock, :message => I18n.t('global.unauthorized')

    @type = Apptype.find(params[:apptype_id])
    @stocks = @Apptype.stocks
  end

  def type_stock_index
    authorize! :type_stock, Stock, :message => I18n.t('global.unauthorized')

    stock_ids = Apptype.find(params[:apptype_id]).stock_ids.sort
    all_stocks = Stock.where(company_id: params[:company_id])

    stocks = Array.new
    all_stocks.each do |stock|
      unless stock_ids.include? stock.id
        stocks << stock
      end
    end
    @stocks = Kaminari.paginate_array(stocks).page(params[:page]).per(25)
  end

  def type_stock_add
    authorize! :type_stock, Stock, :message => I18n.t('global.unauthorized')

    type = Apptype.find(params[:apptype_id])
    unless Apptype.stock_ids.include? params[:stock_id]
      Apptype.stocks << Stock.find(params[:stock_id])
      redirect_to type_stock_path(params[:company_id], params[:apptype_id]), :notice => I18n.t('stock.controller.stock_added_type')
    end
  end

  def type_stock_remove
    authorize! :type_stock, Stock, :message => I18n.t('global.unauthorized')

    Apptype.find(params[:apptype_id]).stocks.delete(Stock.find(params[:stock_id]))
      redirect_to type_stock_path(params[:company_id], params[:apptype_id]), :notice => I18n.t('stock.controller.stock_deleted_type')
  end
end
