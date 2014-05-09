class Appliance < ActiveRecord::Base
  has_many :apptypes

  validates :name, presence: true
  validates :abb, presence: true
  #validates :preview, presence: true

  validates_uniqueness_of :name
  validates_uniqueness_of :abb

  has_attached_file :preview, :styles => { :thumb => "100x100>" }, :path => ':rails_root/public:url', :url => '/system/appliances/:id/:style/:filename'
end
