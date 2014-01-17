class Stats < ActiveRecord::Base

  # checks entry status and return the status number
  def process_status entry
    if entry.sent == 1
      return 6
    end

    if entry.ready == 1
      return 5
    end

    if entry.accessoires == 1
      return 4
    end

    if entry.scrap == 1
      return 3
    end

    if entry.repaired == 1
      return 2
    end

    if (entry.test == 1 or (!entry.defect.nil? and entry.defect.length != 0))
      return 1
    end

    return 0
  end

  def build_chart title, series
    chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie"} )
      f.series(series)
      f.options[:title][:text] = 'Status for ' + title
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
      f.plot_options(:pie=>{
        :allowPointSelect=>true, 
        :cursor=>"pointer" , 
        :dataLabels=>{
          :enabled=>true,
          :color=>"black",
          :style=>{
            :font=>"13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end
  end

  # generates a chart based on title and data
  def generate_chart title, subtitle, data
    series = {
      :type=> 'pie',
      :name=> 'Amount',
      :data=> [
        [ 'New', data[0].to_f ],
        [ 'Tested', data[1].to_f ],
        [ 'Repaired', data[2].to_f ],
        [ 'Scrap', data[3].to_f ],
        [ 'Waiting', data[4].to_f ],
        [ 'Ready', data[5].to_f ],
        {
          :name=> 'Sent',    
          :y=> data[6].to_f,
          :sliced=> true,
          :selected=> true
        }
      ]
    }
    chart = build_chart(title, series)
  end

  def generate_chart_status title, subtitle, data
    series = {
      :type=> 'pie',
      :name=> 'Amount',
      :data=> [
        [ 'Tested', data[0].to_f ],
        [ 'Repaired', data[1].to_f ],
        {
           :name=> 'Scrap',    
           :y=> data[2].to_f,
           :sliced=> true,
           :selected=> true
        }
      ]
    }
    chart = build_chart(title, series)
  end
end
