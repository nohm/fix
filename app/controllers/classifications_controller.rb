class ClassificationsController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Classifications, :message => 'You\'re not authorized for this.'

    @classification = Classifications.new
  end

  def index
    authorize! :index, Classifications, :message => 'You\'re not authorized for this.'

    @classifications = Classifications.all.page(params[:page]).per(25)
  end

  def create
    authorize! :create, Classifications, :message => 'You\'re not authorized for this.'

    @classification = Classifications.new(params[:classification].permit(:name))

    if @classification.save
      redirect_to classifications_path, :notice => "Classification added."
    else
      render 'new'
    end
  end
  
end

