class Entry < ActiveRecord::Base
  has_many :attachments, dependent: :destroy
  
  validates :number, presence: true
  validates :appliance_id, presence: true
  validates :brand, presence: true
  validates :typenum, presence: true
  validates :serialnum, presence: true

  before_save :format_input

  def format_input
    self.brand = self.brand.titleize #stupid missing bang
    self.typenum.upcase!
    self.serialnum.upcase!
  end

  def get_barcode(number)
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/svg_outputter'

    barcode = Barby::Code128B.new("#{number}")
    barcode.to_svg(xdim:2, height:60)
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

  def get_status
    status = 'New'

    if self.test == 1 or (!self.defect.nil? and self.defect.length != 0)
      status = 'Tested'
    end

    if self.repaired == 1
      status = 'Repaired'
    end

    if self.scrap == 1
      status = 'Scrap'
    end

    if self.accessoires == 1
      status = 'Waiting for accessoires'
    end

    if self.ready == 1
      status = 'Ready'
    end

    if self.sent == 1
      status = 'Sent ' + Invoice.where(id: self.invoice_id).first.created_at.to_date.to_s
    end

    # return status
    status
  end
end
