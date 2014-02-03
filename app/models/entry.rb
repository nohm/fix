class Entry < ActiveRecord::Base
  belongs_to :company
  belongs_to :type
  belongs_to :classifications
  belongs_to :invoice
  
  has_many :attachments, dependent: :destroy
  
  validates :number, presence: true
  validates :type_id, presence: true
  validates :serialnum, presence: true
  validates :company_id, presence: true

  before_save :format_input
  after_save :update_status

  def format_input
    self.serialnum.upcase!
  end

  def update_status
    new_status = get_status
    unless new_status == self.status
      self.update_attribute(:status, new_status)
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

  def get_status_translated
    if I18n.locale == :en
      status = self.status
    else
      status = I18n.t('entry.status.new')

      if self.test == 1 or (!self.defect.nil? and self.defect.length != 0)
        status = I18n.t('entry.status.tested')
      end

      if self.repaired == 1
        status = I18n.t('entry.status.repaired')
      end

      if self.scrap == 1
        status = I18n.t('entry.status.scrap')
      end

      if self.accessoires == 1
        status = I18n.t('entry.status.accessoires')
      end

      if self.ready == 1
        status = I18n.t('entry.status.ready')
      end

      if self.sent == 1
        status = I18n.t('entry.status.sent') + Invoice.where(id: self.invoice_id).first.created_at.to_date.to_s
      end

      # return status
      status
    end
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

end
