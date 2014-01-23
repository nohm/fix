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

  def build_chart title, data
    LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie"} )
      series = {
        :type=> 'pie',
        :name=> I18n.t('stats.status.amount'),
        :data=> data
      }
      f.series(series)
      f.options[:title][:text] = I18n.t('stats.status.label') + title
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
  def generate_chart title, subtitle, data, extended
    if extended
      data = [
        [ I18n.t('stats.status.new'), data[0].to_f ],
        [ I18n.t('stats.status.tested'), data[1].to_f ],
        [ I18n.t('stats.status.repaired'), data[2].to_f ],
        [ I18n.t('stats.status.scrap'), data[3].to_f ],
        [ I18n.t('stats.status.waiting'), data[4].to_f ],
        [ I18n.t('stats.status.ready'), data[5].to_f ],
        {
          :name=> I18n.t('stats.status.sent'),    
          :y=> data[6].to_f,
          :sliced=> true,
          :selected=> true
        }
      ]
      build_chart(title, data)
    else
      generate_bar_chart([I18n.t('stats.status.new'),I18n.t('stats.status.tested'),I18n.t('stats.status.repaired'),I18n.t('stats.status.scrap'),I18n.t('stats.status.waiting'),I18n.t('stats.status.ready'),I18n.t('stats.status.sent')], 6, data)
    end
  end

  def generate_chart_status title, subtitle, data, extended
    if extended
      data = [
        [ I18n.t('stats.status.tested'), data[0].to_f ],
        [ I18n.t('stats.status.repaired'), data[1].to_f ],
        {
          :name=> I18n.t('stats.status.scrap'),    
          :y=> data[2].to_f,
          :sliced=> true,
          :selected=> true
        }
      ]
      build_chart(title, data)
    else
      generate_bar_chart([I18n.t('stats.status.tested'),I18n.t('stats.status.repaired'),I18n.t('stats.status.scrap'),I18n.t('stats.status.skipped')], 3, data)
    end
  end

  def generate_bar_chart labels, length, data
      count = 0
      data.each do |c|
        count = count + c
      end
      bar = '<div class="progress">'
      (0..length).each do |i|
        bar << build_bar(((data[i].to_f / count.to_f) * 100.0).to_s, labels[i])
      end
      bar << '</div>'
      bar << '<table class="table table-condensed">'
      (0..length).each do |i|
        bar << build_label(((data[i].to_f / count.to_f) * 100.0).round(1).to_s, data[i].to_s, labels[i])
      end
      bar << "<tr><td>100%</td><td>(#{count})</td><td>#{I18n.t('stats.status.total')}</td><td></td>"
      bar << '</table>'
  end

  def build_bar width, label
    "<div class=\"progress-bar stat-colour-#{label.downcase}\" style=\"width:#{width}%\"><span class=\"sr-only\">#{width}% #{label}</span></div>"
  end

  def build_label width, count, label
    "<tr><td>#{width}%</td><td>(#{count})</td><td>#{label}</td><td><span class=\"stat-colour-#{label.downcase} stat-colour-none\">&#11044;</span></td></tr>"
  end
end
