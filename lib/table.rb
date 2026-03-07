# frozen_string_literal: true

class ReportTable

  def initialize &block
    instance_eval(&block)
  end

  def render
    counters = {}
    result = []
    result << '<table>'
    result << '<tr>'
    @columns.each do |col|
      col_style = ''
      col_style += "text-align:#{ col[:align] };" if col[:align]
      col_style += "width:#{ col[:width] };" if col[:width]
      col_style = " style=\"#{ col_style }\"" unless col_style.empty?
      result << "<th#{ col_style }>#{ col[:title] }</th>"
    end
    result << '</tr>'
    @rows.each do |row|
      if row[:style]
        result << "<tr style=\"#{ row[:style] }\">"
      else
        result << '<tr>'
      end
      @columns.each do |col|
        name = col[:name]
        text = row[name]
        if text.nil?
          if col[:auto]
            counters[name] ||= 0
            counters[name] += 1
            text = counters[name].to_s
          else
            text = ''
          end
        else
          text = text.to_s
        end
        link = row["#{ name }_link".to_sym]
        text = "<a href=\"#{ mk_link(link) }\">#{ text }</a>" if link
        col_style = ''
        col_style += "text-align:#{ col[:align] };" if col[:align]
        col_style += "width:#{ col[:width] };" if col[:width]
        col_style = " style=\"#{ col_style }\"" unless col_style.empty?
        result << "<td#{ col_style }>#{ text }</td>"
      end
      result << '</tr>'
    end
    result << '</table>'
    result.join "\n"
  end

  def << data
    @rows ||= []
    if data.is_a?(Enumerable)
      @rows += data.to_a
    else
      @rows += data
    end
    self
  end

  private

  def column name, title, width: nil, align: nil, auto: false
    @columns ||= []
    @columns << { name: name, title: title, width: width, align: align, auto: auto }
  end

  def mk_link src
    return src if src.is_a?(String)
    result = []
    src.each do |key, value|
      value = value.map(&:to_s).join(',') if value.is_a?(Enumerable)
      result << "#{ key }=#{ value }"
    end
    result << "place_id=any" unless src[:place_id]
    "https://www.inaturalist.org/observations?#{ result.join('&') }"
  end

end
