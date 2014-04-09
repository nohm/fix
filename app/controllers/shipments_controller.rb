class ShipmentsController < ApplicationController
  before_filter :authenticate_user!

   def index
    authorize! :index, Shipment, :message => I18n.t('global.unauthorized')

    @shipments = Shipment.where(company_id: params[:company_id]).order('id ASC').page(params[:page]).per(10)

    @current_status = Array.new
    @shipments.each do |shipment|
      shipment_status = Hash.new
      type_count = shipment.entries.group(:type_id).uniq.count.sort
      type_count = Hash[type_count.sort_by{ |_, v| -v }] # sort by count

      type_names = Type.select('id, brand, typenum').find(type_count.keys)
      type_names.each do |type|
        shipment_status[type.brand_type] = type_count[type.id]
      end

      @current_status << shipment_status
    end

    @company = Company.find(params[:company_id])
  end

  def new
  	authorize! :new, Shipment, :message => I18n.t('global.unauthorized')

    @shipment = Shipment.new
  end

  def create
    authorize! :create, Shipment, :message => I18n.t('global.unauthorized')

    params[:shipment][:company_id] = params[:company_id]

    @shipment = Shipment.new(params[:shipment].permit(:company_id,:number,:expectance))
    if @shipment.save
      redirect_to company_shipments_path(params[:company_id]), :notice => I18n.t('shipment.controller.shipment_added')
    else
      render 'new'
    end
  end
end
