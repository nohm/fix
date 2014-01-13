class Entry < ActiveRecord::Base
  has_many :attachments, dependent: :destroy
  
  validates :number, presence: true
  validates :appliance_id, presence: true
  validates :brand, presence: true
  validates :typenum, presence: true
  validates :serialnum, presence: true
  validates :company, presence: true

  before_save :format_input

  def format_input
    self.brand = self.brand.titleize #stupid missing bang
    self.typenum.upcase!
    self.serialnum.upcase!
  end

  def get_barcode(number)
    require 'barby'
    require 'barby/barcode/code_39'
    require 'barby/outputter/svg_outputter'

    barcode = Barby::Code39.new("#{number}")
    barcode.to_svg(height: 60, xdim: 3)
  end

  def zip_images(temp_file)
    require 'zip'

    Zip::OutputStream.open(temp_file.path) do |zos|
      self.attachments.each do |attachment|
        zos.put_next_entry(attachment.attach_file_name)
        zos.print IO.read(attachment.attach.path)
      end
    end
  end

  def get_status data
    status = 'New'

    if data[:test] == "1" or (!data[:defect].nil? and data[:defect].length != 0)
      status = 'Tested'
    end

    if data[:repaired] == "1"
      status = 'Repaired'
    end

    if data[:scrap] == "1"
      status = 'Scrap'
    end

    if data[:accessoires] == "1"
      status = 'Waiting for accessoires'
    end

    if data[:ready] == "1"
      status = 'Ready'
    end

    if data[:sent] == "1"
      status = 'Sent ' + Invoice.where(id: data[:invoice_id]).first.created_at.to_date.to_s
    end

    # return status
    status
  end
end
