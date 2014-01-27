class Appliance < ActiveRecord::Base

  validates :name, presence: true
  validates :abb, presence: true
  validates :preview, presence: true

  validates_uniqueness_of :name
  validates_uniqueness_of :abb

end
