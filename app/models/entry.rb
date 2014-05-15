class Entry < ActiveRecord::Base
  belongs_to :company
  belongs_to :apptype
  belongs_to :classifications
  belongs_to :invoice
  belongs_to :shipment
  
  has_many :attachments, dependent: :destroy
  
  validates :number, presence: true
  validates :apptype_id, presence: true
  validates :serialnum, presence: true
  validates :company_id, presence: true

  validate :unique_serial

  before_save :format_input, :update_stock
  after_save :update_status

  def unique_serial
    # Find all the matching types
    type_ids = Apptype.where(brand: self.apptype.brand, typenum: self.apptype.typenum).ids
    # Find all matching serials for those types
    entry_numbers = []
    entries = Entry.includes(:apptype,:company).where(apptype_id: type_ids, serialnum: self.serialnum)
    entries.each do |entry|
      unless entry.id == self.id
        entry_numbers.append("#{entry.company.abb}#{entry.apptype.appliance.abb}#{entry.number}")
      end
    end
    unless entry_numbers.empty?
      errors.add(:serialnum, "#{I18n.t('entry.controller.duplicate')}#{entry_numbers.join(', ')}")
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
      status = 'Sent ' + Invoice.find(self.invoice_id).created_at.to_date.to_s
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

  def get_trigger
    type = ''

    unless self.note.nil? or self.note.empty?
      triggers = {
        '$lost' => ' class=danger',
        '$sample' => ' class=info'
      }
      note_lines = self.note.lines.map {|x| x.chomp}

      note_lines.each do |line|
        if triggers.keys.include? line
          type = triggers[line]
        end
      end
    end

    type
  end

  def process_triggers(note, who)
    response = true

    unless self.note.nil? or note.nil?
      triggers_found = 0
      triggers = ['$lost', '$sample']
      note_lines = note.lines.map {|x| x.chomp}
      self_lines = self.note.lines.map {|x| x.chomp}

      self_lines.each do |line|
        if triggers.include? line
          triggers_found += 1
        end
        if triggers.include? line and !note_lines.include? line and (who.staff? and !who.manager?)
          response = false
          errors.add(:note, 'You\'re not allowed to add a trigger!')
        end
        if triggers_found > 1
          response = false
          errors.add(:note, 'Max. 1 trigger per entry!')
        end
      end
    end

    response
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

  private
    def format_input
      self.serialnum.upcase!
    end

    def update_status
      new_status = get_status
      unless new_status == self.status
        self.update_attribute(:status, new_status)
      end
    end

    def update_stock
      Stock.new.update_stock(self)
    end
end
