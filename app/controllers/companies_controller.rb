class CompaniesController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Company, :message => I18n.t('global.unauthorized')

    @company = Company.new
  end

  def index
    authorize! :index, Company, :message => I18n.t('global.unauthorized')

    @companies = Company.all.page(params[:page]).order('id ASC').per(25)

  end

  def create
    authorize! :create, Company, :message => I18n.t('global.unauthorized')

    @companies = Company.new(params[:company].permit(:title,:short,:abb,:adress))

    if @companies.save
      redirect_to companies_path, :notice => 'Added'
    else
      render 'new'
    end
  end
  
end

