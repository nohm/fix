class AppliancesController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Appliance, :message => 'You\'re not authorized for this.'

    @appliance = Appliance.new
  end

  def index
    authorize! :index, Appliance, :message => 'You\'re not authorized for this.'

    @appliances = Appliance.all.page(params[:page]).per(25)
  end

  def create
    authorize! :create, Appliance, :message => 'You\'re not authorized for this.'

    @appliance = Appliance.new(params[:appliance].permit(:name,:abb))

    if @appliance.save
      redirect_to appliances_path, :notice => "Appliance added."
    else
      render 'new'
    end
  end
  
end
