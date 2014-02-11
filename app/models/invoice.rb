class Invoice < ActiveRecord::Base
  belongs_to :company

  has_many :entries

  attr_accessor :items
end
