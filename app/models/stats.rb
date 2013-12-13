class Stats < ActiveRecord::Base

  # checks entry status and return the status number
  def process_status entry
    if entry.sent == 1
      return 6
    end

    if entry.ready == 1 and processed == 0
      return 5
    end

    if entry.accessoires == 1 and processed == 0
      return 4
    end

    if entry.scrap == 1 and processed == 0
      return 3
    end

    if entry.repaired == 1 and processed == 0
      return 2
    end

    if (entry.test == 1 or (!entry.defect.nil? and entry.defect.length != 0)) and processed == 0
      return 1
    end

    return 0
  end

  # generates a chart based on title and data
  def generate_chart title, data
    chart = LazyHighCharts::HighChart.new('column') do |f|
      f.chart({ type: 'column', marginRight: 130, marginBottom: 25 })
      f.title({ text: 'Status for ' + title, x: -20 })
      f.yAxis({ title: { text: 'Amount' }, plotLines: [{ value: 0, width: 1, color: '#808080' }] })
      f.xAxis({ categories: ['Status'] })
      f.legend({ layout: 'vertical', align: 'right', verticalAlign: 'top', x: -10, y: 100, borderWidth: 0 })
      
      f.series({ name: 'New', data: [data[0].to_f] })
      f.series({ name: 'Tested', data: [data[1].to_f] })
      f.series({ name: 'Repaired', data: [data[2].to_f] })
      f.series({ name: 'Scrap', data: [data[3].to_f] })
      f.series({ name: 'Waiting', data: [data[4].to_f] })
      f.series({ name: 'Ready', data: [data[5].to_f] })
      f.series({ name: 'Sent', data: [data[6].to_f] })
    end
  end

end
