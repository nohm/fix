class AppliancesController < ApplicationController

  def new
    @appliance = Appliance.new
  end

  def index
    @appliances = Appliance.all.page(params[:page]).per(25)
  end

  def create
    @appliance = Appliance.new(params[:appliance].permit(:name,:abb))

    if @appliance.save
      redirect_to appliances_path, :notice => "Appliance added."
    else
      render 'new'
    end
  end
end
