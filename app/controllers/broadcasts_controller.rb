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
      redirect_to broadcasts_path, :notice => 'Broadcast added'
    else
      render 'new'
    end
  end

  def destroy
    authorize! :destroy, Broadcast, :message => I18n.t('global.unauthorized')

    broadcast = Broadcast.find(params[:id])
    broadcast.destroy
    redirect_to broadcasts_path, :notice => 'Broadcast deleted'
  end

  def retrieve
  	authorize! :retrieve, Broadcast, :message => I18n.t('global.unauthorized')

  	broadcasts = Broadcast.all
  	to_send = Array.new
  	broadcasts.each do |broadcast|
  		if broadcast.user_ids.nil?
  			to_send.append({id: broadcast.id, title: broadcast.title, text: broadcast.text})
  		else
  			found = false
  			broadcast.user_ids.split(':').each do |user|
  				if current_user.id == user.to_i
  					found = true
  				end
  			end
  			unless found
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
  	unless broadcast.user_ids.nil?
  		users = broadcast.user_ids.split(':')
  	else
  		users = Array.new
  	end
  	found = false
  	users.each do |user|
  		if current_user.id == user.to_i
  			found = true
  		end
  	end
  	unless found
  		if broadcast.user_ids == '' or broadcast.user_ids.nil?
  			new_ids = current_user.id
  		else
  			new_ids = broadcast.user_ids << ':' + current_user.id.to_s
  		end
  		broadcast.update_attribute(:user_ids, new_ids)
  	end

  	respond_to do |format|
  		format.js { render :json => '202 OK'}
  	end
  end

end