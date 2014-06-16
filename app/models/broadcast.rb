class Broadcast < ActiveRecord::Base
  validates :title, presence: true
  validates :text, presence: true

  def self.retrieve_broadcasts(current_user)
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
  	to_send
  end
end
