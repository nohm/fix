class Home

  def self.generate_bar_chart labels, length, data
        count = 0
        data.each do |c|
          count = count + c
        end
        bar = '<div class="progress">'
        (0..length).each do |i|
          bar << build_bar(((data[i].to_f / count.to_f) * 100.0).to_s, labels[i].to_s)
        end
        bar << '</div>'
        bar << '<table class="table table-condensed">'
        (0..length).each do |i|
          bar << build_label(((data[i].to_f / count.to_f) * 100.0).round(1).to_s, data[i].to_s, labels[i].to_s)
        end
        bar << "<tr><td>100%</td><td>(#{count})</td><td>#{I18n.t('stats.status.total')}</td><td></td>"
        bar << '</table>'
    end

    def self.build_bar width, label
      "<div class=\"progress-bar stat-colour-#{label.downcase}\" style=\"width:#{width}%\"><span class=\"sr-only\">#{width}% #{label}</span></div>"
    end

    def self.build_label width, count, label
      "<tr><td>#{width}%</td><td>(#{count})</td><td>#{label}</td><td><span class=\"stat-colour-#{label.downcase} stat-colour-circle\">-</span></td></tr>"
    end

end
