class Type < ActiveRecord::Base
  belongs_to :company
  belongs_to :appliance

  has_many :entries

  validates :appliance_id, presence: true
  validates :brand, presence: true
  validates :typenum, presence: true
  validates :test_price, presence: true
  validates :repair_price, presence: true
  validates :scrap_price, presence: true

  before_save :format_input

  def format_input
    self.brand = self.brand.titleize #stupid missing bang
    self.typenum.upcase!
  end

  def brand_type
    "#{self.brand}_#{self.typenum}".gsub(' ', '_')
  end
end
