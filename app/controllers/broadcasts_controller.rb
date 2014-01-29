class BroadcastsController < ApplicationController
  def new
    authorize! :new, Broadcast, :message => I18n.t('global.unauthorized')

    @broadcast = Broadcast.new
  end

  def index
    authorize! :index, Broadcast, :message => I18n.t('global.unauthorized')

    @broadcasts = Broadcast.all
  end

  def create
    authorize! :create, Broadcast, :message => I18n.t('global.unauthorized')

    @broadcast = Broadcast.new(params[:broadcast].permit(:title,:text))

    if @broadcast.save
      redirect_to broadcasts_path, :notice => I18n.t('broadcast.controller.notice_added')
    else
      render 'new'
    end
  end

  def destroy
    authorize! :destroy, Broadcast, :message => I18n.t('global.unauthorized')

    broadcast = Broadcast.find(params[:id])
    broadcast.destroy
    redirect_to broadcasts_path, :notice => I18n.t('broadcast.controller.notice_deleted')
  end

  def retrieve
  	authorize! :retrieve, Broadcast, :message => I18n.t('global.unauthorized')

  	broadcasts = Broadcast.all
  	to_send = Array.new
  	broadcasts.each do |broadcast|
  		if broadcast.user_ids.nil?
  			to_send.append({id: broadcast.id, title: broadcast.title, text: broadcast.text})
  		else
  			unless broadcast.user_ids.split(':').include?(current_user.id.to_s)
  				to_send.append({id: broadcast.id, title: broadcast.title, text: broadcast.text})
  			end
  		end
  	end

  	respond_to do |format|
  		format.js { render :json => to_send}
  	end
  end

  def disable
  	authorize! :disable, Broadcast, :message => I18n.t('global.unauthorized')

  	broadcast = Broadcast.find(params[:id])
  	unless !broadcast.user_ids.nil? and broadcast.user_ids.split(':').include?(current_user.id.to_s)
  		if broadcast.user_ids.nil?
  			new_ids = current_user.id
  		else
  			new_ids = "#{broadcast.user_ids}:#{current_user.id.to_s}"
  		end
  		broadcast.update_attribute(:user_ids, new_ids)
  	end

  	respond_to do |format|
  		format.js { render :json => '202 OK'}
  	end
  end

end
