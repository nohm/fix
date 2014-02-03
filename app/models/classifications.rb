class Classifications < ActiveRecord::Base
  has_many :entries

  validates :name, presence: true

  validates_uniqueness_of :name

end
