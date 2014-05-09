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

    @company = Company.new(params[:company].permit(:title,:short,:abb,:address,:mail))

    if @company.save
      Role.create(name: @company.short)
      redirect_to companies_path, :notice => I18n.t('company.controller.company_added')
    else
      render 'new'
    end
  end

  def destroy
    authorize! :destroy, Company, :message => I18n.t('global.unauthorized')

    company = Company.find(params[:id])
    company.destroy
    redirect_to companies_path, :notice => I18n.t('company.controller.company_deleted')
  end

  def edit
    authorize! :edit, Company, :message => I18n.t('global.unauthorized')

    @company = Company.find(params[:id])
  end

  def update
    authorize! :update, Company, :message => I18n.t('global.unauthorized')

    @company = Company.find(params[:id])

    if @company.update(params[:company].permit(:title,:short,:abb,:address,:mail))
      Role.where(name: @company.short).first.update(name: @company.short)
      redirect_to companies_path, :notice => I18n.t('company.controller.company_updated')
    else
      render 'edit'
    end
  end
  
end

