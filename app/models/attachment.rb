class Attachment < ActiveRecord::Base
  belongs_to :entry
  has_attached_file :attach, :styles => { :thumb => "100x100>" }, :path => ':rails_root/public:url', :url => '/system/entries/:id/attachments/:style/:filename'
end
