# frozen_string_literal: true

require 'fileutils'

FileUtils.mkdir_p 'output'

require_relative 'districts'
require_relative 'table'

class BaseReport

  include INatGet::Data::DSL
  extend INatGet::Data::DSL

  PREAMBLE = <<~TXT
    <i>Учитываются только наблюдения исследовательского уровня. В подсчете видов — только виды и гибриды — старшие таксоны игнорируются, младшие приводятся к видам. Из-за этого выборки по наблюдениям и видам могут расходиться между собой.</i>
  TXT

  SIGNATURE = <<~TXT
    <hr>
    <small>Отчет составлен посредством <a href=\"https://github.com/inat-get/inat-get\">🌿 iNatGet v#{version}</a>, конкретные скрипты отчетов размещены в <a href=\"https://github.com/inat-get/ing-sv-districts\">отдельном репозитории</a>.
  TXT

  LAST_YEAR = today.year - 1
  LAST_TIME = finish_time year: LAST_YEAR

  def initialize slug
    @slug = slug
    @opts = {}
  end

  def load_data
    @project = get_project @slug
  end

  def compact_history_rows rows
    return if rows.size <= 10
    first_year = rows.first[:year]
    while rows.size > 10
      first_row = rows.shift
      next_row = rows.first
      next_row[:period] = "<i class=\"glyphicon glyphicon-calendar\"></i>  #{first_year}–#{next_row[:year]} годы"
      next_row[:count] += first_row[:count]
      next_row[:news] += first_row[:news]
      next_row[:species] = next_row[:news]
      count_select = next_row[:count_link]
      count_select.delete :year
      count_select[:d2] = finish_time(year: next_row[:year]).xmlschema.gsub("+", "%2B")
      species_select = count_select.merge({ view: "species", hrank: "species", lrank: "species" })
      next_row[:count_link] = count_select
      next_row[:species_link] = species_select
    end
  end

  def user_html user
    "<a title=\"#{ user.name }\" href=\"https://www.inaturalist.org/people/#{ user.id }\"><i class=\"glyphicon glyphicon-user\"></i></a> @#{ user.login }"
  end

  def taxon_html taxon
    "<a href=\"https://www.inaturalist.org/taxa/#{ taxon.id }\">#{ taxon_icon taxon } #{ taxon_name taxon }</a>"
  end

  def taxon_icon taxon
    "<i class=\"icon-iconic-#{ taxon.iconic.to_s.downcase }\" style=\"font-size:1.5em;height:1em;line-height:1em;\"></i>"
  end

  def taxon_name taxon
    if taxon.common_name
      "#{ taxon.common_name } <i>(#{ taxon.name })</i>"
    else
      "<i>#{ taxon.name }</i>"
    end
  end

  def subject_html subject
    title, icon = if subject.is_a?(INatGet::Data::Model::Place)
      [subject.display_name || subject.name, '<i class="fa fa-globe"></i>']
    else
      [subject.title, '<i class="fa fa-briefcase"></i>']
    end
    url = "https://www.inaturalist.org/#{subject.class.endpoint}/#{subject.id}"
    "<a href=\"#{url}\">#{icon}  #{title}</a>"
  end

  def epilogue
    umbrella = get_project 'bioraznoobrazie-rayonov-sverdlovskoy-oblasti'
    "<i>Присоединяйтесь к данному проекту — «#{ subject_html @project }».\nИ обратите внимание на зонтичный — «#{ subject_html umbrella }», а также соответствующие <a href=\"https://t.me/inat_sverdlobl\">канал и чат в Telegram</a>.</i>"
  end

  def make_history
    result = []
    result << '## История'
    result << ''
    #
    years = @dataset % :observed_year
    years.sort!
    olds = nil
    news = nil
    last = nil
    history_rows = years.map do |ds|
      last = ds
      species = ds % :species
      if olds.nil?
        olds = species
        news = species
      else
        news = species - olds
        olds += species
      end
      count_select = @opts.merge({ project_id: @project.id, year: ds.key })
      species_select = count_select.merge({ hrank: 'species', lrank: 'species', view: 'species' })
      {
        year: ds.key,
        period: "<i class=\"glyphicon glyphicon-calendar\"></i>  #{ ds.key } год",
        count: ds.count,
        species: species.count,
        news: news.count,
        count_link: count_select,
        species_link: species_select
      }
    end
    if last.key != LAST_YEAR
      @last_ds = nil
      @news_ls = nil
      history_rows << { year: LAST_YEAR, period: "<i class=\"glyphicon glyphicon-calendar\"></i>  #{ LAST_YEAR } год", count: 0, species: 0, news: 0 }
    else
      @last_ds = last
      @news_ls = news
    end
    compact_history_rows history_rows
    history_rows.last[:style] = 'font-size:120%;'
    history_rows << { line_no: '', count: @dataset.count, species: (@dataset % :species).count, style: 'font-weight:bold;' }
    table = ReportTable::new do
      column :line_no, '#', width: '3em', align: 'right', auto: true
      column :period, 'Период'
      column :count, 'Наблюдения', width: '8em', align: 'right'
      column :species, 'Виды', width: '6em', align: 'right'
      column :news, 'Новинки', width: '6em', align: 'right'
    end
    table << history_rows
    #
    result << table.render
    result << ''
    result.join("\n")
  end

end

class DistrictReport < BaseReport

  def initialize slug
    super slug
    @opts = { quality_grade: 'research' }
  end

  def load_data
    super
    @dataset = select_observations(project: @project, observed: (... LAST_TIME), **@opts)
  end

  def tops_header
    result = []
    result << '## Лучшие наблюдатели'
    result << ''
    result << 'Топ-10 из набравших не менее 10 видов.'
    result << ''
    result.join("\n")
  end

  def users_top users
    users_rows = users.map do |ds|
      user = ds.key
      count_select = @opts.merge({ project_id: @project.id, year: LAST_YEAR, user_id: user.id })
      species_select = count_select.merge({ hrank: "species", lrank: "species", view: "species" })
      {
        user: user_html(user),
        count: ds.count,
        species: (ds % :species).count,
        count_link: count_select,
        species_link: species_select,
      }
    end
    users_rows.sort_by! { |r| [-r[:species], -r[:count]] }
    users_rows = users_rows.first 10
    users_table = ReportTable::new do
      column :line_no, "#", width: "3em", align: "right", auto: true
      column :user, "Наблюдатель"
      column :count, "Наблюдения", width: "8em", align: "right"
      column :species, "Виды", width: "6em", align: "right"
    end
    users_table << users_rows
    users_table.render
  end

  def make_news
    result = []
    if @news_ls && @news_ls.count > 0
      result << '## Новинки'
      result << ''
      result << 'Таксоны, наблюдавшиеся в этом сезоне впервые.'
      result << ''
      @news_ls.sort!
      news_users = {}
      news_rows = @news_ls.map do |ds|
        taxon = ds.key
        users = ds % :user
        users.each do |uds|
          user = uds.key
          news_users[user] ||= { count: 0, species: 0 }
          news_users[user][:count] += uds.count
          news_users[user][:species] += 1
        end
        count_select = @opts.merge({ project_id: @project.id, year: LAST_YEAR, taxon_id: taxon.id })
        users_select = count_select.merge({ view: 'observers' })
        {
          taxon: taxon_html(taxon),
          count: ds.count,
          users: users.count,
          count_link: count_select,
          users_link: users_select
        }
      end
      taxa_table = ReportTable::new do
        column :line_no, '#', width: '3em', align: 'right', auto: true
        column :taxon, 'Таксон'
        column :count, 'Наблюдения', width: '8em', align: 'right'
        column :users, 'Люди', width: '6em', align: 'right'
      end
      taxa_table << news_rows
      result << taxa_table.render
      result << ''
      users_rows = news_users.map do |key, value|
        value.merge({ user: user_html(key) })
      end
      users_rows.sort_by! { |r| [ -r[:species], -r[:count] ] }
      users_table = ReportTable::new do
        column :line_no, '#', width: '3em', align: 'right', auto: true
        column :user, 'Наблюдатель'
        column :count, 'Наблюдения', width: '8em', align: 'right'
        column :species, 'Виды', width: '6em', align: 'right'
      end
      users_table << users_rows
      result << '### Наблюдатели новинок'
      result << ''
      result << users_table.render
      result << ''
    end
    result.join("\n")
  end

  def make_tops
    result = []
    header_added = false
    if @last_ds && @last_ds.count > 0
      users = @last_ds % :user
      users.filter! { |ds| ds.count > 10 }
      if users.count > 0
        result << tops_header
        header_added = true
        result << '### За сезон'
        result << ''
        result << users_top(users)
        result << ''
        users.filter! { |ds| ds.key.created.year == LAST_YEAR }
        if users.count > 0
          result << '### Новички'
          result << ''
          result << users_top(users)
          result << ''
        end
      end
    end
    users = @dataset % :user
    users.filter! { |ds| ds.count > 10 }
    if users.count > 0
      result << tops_header unless header_added
      result << '### За все время'
      result << ''
      result << users_top(users)
      result << ''
    end
    result.join("\n")
  end

  def write_history
    load_data
    result = []
    result << PREAMBLE
    result << ''
    result << make_history
    result << ''
    result << make_tops
    result << ''
    result << make_news
    result << ''
    result << epilogue
    result << ''
    result << SIGNATURE
    File.write "output/#{ @slug } - history.md", result.join("\n")
  end

  def load_neighbors
    @neighbors = {}
    data = DISTRICTS[@slug][:neighbors]
    data[:projects].each do |prj|
      project = get_project prj
      dataset = select_observations(project: project, observed: (... finish_time(year: LAST_YEAR)), **@opts)
      @neighbors[project] = { dataset: dataset, species: (dataset % :species), users: (dataset % :user).count }
    end
    data[:places].each do |plc|
      place = get_place plc
      dataset = select_observations(place: place, observed: (... finish_time(year: LAST_YEAR)), **@opts)
      @neighbors[place] = { dataset: dataset, species: (dataset % :species), users: (dataset % :user).count }
    end
  end

  def neighbors_table
    result = []
    result << 'Сравнение выполнялось со следующими проектами/территориями:'
    total = nil
    rows = @neighbors.map do |key, value|
      if total.nil?
        total = value[:dataset]
      else
        total += value[:dataset]
      end
      count_select = @opts.merge({ d2: LAST_TIME.xmlschema.gsub('+', '%2B') })
      if key.is_a?(INatGet::Data::Model::Place)
        count_select.merge!({ place_id: key.id })
      else
        count_select.merge!({ project_id: key.id })
      end
      species_select = count_select.merge({ hrank: 'species', lrank: 'species', view: 'species' })
      users_select = count_select.merge({ view: 'observers' })
      {
        type: (key.is_a?(INatGet::Data::Model::Place) ? 1 : 0),
        title: (key.is_a?(INatGet::Data::Model::Place) ? (key.display_name || key.name) : key.title),
        subject: subject_html(key),
        count: value[:dataset].count,
        species: value[:species].count,
        users: value[:users],
        count_link: count_select,
        species_link: species_select,
        users_link: users_select
      }
    end
    rows.sort_by! { |r| [ r[:type], r[:title] ] }
    rows << { line_no: '', count: total.count, species: (total % :species).count, users: (total % :user).count, style: 'font-weight:bold;' }
    table = ReportTable::new do
      column :line_no, '#', width: '3em', align: 'right', auto: true
      column :subject, 'Проект / место'
      column :count, 'Наблюдения', width: '8em', align: 'right'
      column :species, 'Виды', width: '6em', align: 'right'
      column :users, 'Люди', width: '6em', align: 'right'
    end
    table << rows
    result << table.render
    result << ''
    result.join("\n")
  end

  def make_unique
    result = []
    @species = @dataset % :species
    uniques = @species
    @neighbors.each do |_, value|
      uniques -= value[:species]
    end
    if uniques.count > 0
      result << '## «Уники»'
      result << ''
      result << 'Таксоны, наблюдавшиеся здесь, но не найденные ни у кого из соседей.'
      result << ''
      uniques.sort!
      uniques_users = {}
      uniques_rows = uniques.map do |ds|
        taxon = ds.key
        users = ds % :user
        users.each do |uds|
          user = uds.key
          uniques_users[user] ||= { count: 0, species: 0 }
          uniques_users[user][:count] += uds.count
          uniques_users[user][:species] += 1
        end
        count_select = @opts.merge({ project_id: @project.id, d2: LAST_TIME.xmlschema.gsub('+', '%2B'), taxon_id: taxon.id })
        users_select = count_select.merge({ view: 'observers' })
        {
          taxon: taxon_html(taxon),
          count: ds.count,
          users: users.count,
          count_link: count_select,
          users_link: users_select
        }
      end
      taxa_table = ReportTable::new do
        column :line_no, '#', width: '3em', align: 'right', auto: true
        column :taxon, 'Таксон'
        column :count, 'Наблюдения', width: '8em', align: 'right'
        column :users, 'Люди', width: '6em', align: 'right'
      end
      taxa_table << uniques_rows
      result << taxa_table.render
      result << ''
      users_rows = uniques_users.map do |key, value|
        value.merge({ user: user_html(key) })
      end
      users_rows.sort_by! { |r| [ -r[:species], -r[:count] ] }
      users_table = ReportTable::new do
        column :line_no, "#", width: "3em", align: "right", auto: true
        column :user, "Наблюдатель"
        column :count, "Наблюдения", width: "8em", align: "right"
        column :species, "Виды", width: "6em", align: "right"
      end
      users_table << users_rows
      result << "### Наблюдатели «уников»"
      result << ""
      result << users_table.render
      result << ""
    end
    result.join("\n")
  end

  def make_wanted
    result = []
    neighbors_select = {}
    places, projects = @neighbors.keys.partition { |n| n.is_a?(INatGet::Data::Model::Place) }
    if places.empty?
      neighbors_select.merge!({ project_id: projects.map(&:id).map(&:to_s).join(',') })
    else
      places += projects.map(&:included_places).flatten
      neighbors_select.merge!({ place_id: places.map(&:id).map(&:to_s).join(',') })
    end
    commons = List::commons(2, *@neighbors.values.map { |v| v[:species] })
    wanted = commons - @species
    if wanted.count > 0
      result << '## «Разыскиваются»'
      result << ''
      result << "Топ-50 (из #{ wanted.count }) таксонов, найденных не менее, чем у двух соседей, но пока не обнаруженных здесь."
      result << ''
      wanted_rows = wanted.map do |ds|
        taxon = ds.key
        users = ds % :user
        count_select = @opts.merge(neighbors_select).merge({ d2: LAST_TIME.xmlschema.gsub('+', '%2B'), taxon_id: taxon.id })
        users_select = count_select.merge({ view: 'observers' })
        {
          raw_taxon: taxon,
          taxon: taxon_html(taxon),
          count: ds.count,
          users: users.count,
          count_link: count_select,
          users_link: users_select
        }
      end
      wanted_rows.sort_by! { |r| [ -r[:count], -r[:users] ] }
      wanted_rows = wanted_rows.first 50
      wanted_rows.sort_by! { |r| r[:raw_taxon] }
      wanted_table = ReportTable::new do
        column :line_no, '#', width: '3em', align: 'right', auto: true
        column :taxon, 'Таксон'
        column :count, 'Наблюдения', width: '8em', align: 'right'
        column :users, 'Люди', width: '6em', align: 'right'
      end
      wanted_table << wanted_rows
      result << wanted_table.render
      result << ''
    end
    result.join("\n")
  end

  def write_comparison
    load_neighbors
    result = []
    result << PREAMBLE
    result << ''
    result << neighbors_table
    result << ''
    result << make_unique
    result << ''
    result << make_wanted
    result << ''
    result << epilogue
    result << ''
    result << SIGNATURE
    File.write "output/#{ @slug } - comparison.md", result.join("\n")
  end

end

class AreaReport < DistrictReport

  def load_data
    @project = get_project @slug
    content = ZONES[@slug][:content]
    content.each do |subslug|
      prj = get_project subslug
      dts = select_observations(project: prj, observed: (... LAST_TIME), **@opts)
      dts.update!
      unless @dataset
        @dataset = dts
      else
        @dataset += dts
      end
    end
  end

  def load_neighbors
    @neighbors = {}
    neighbors = ZONES.reject { |k, _| k == @slug }
    neighbors.each do |key, value|
      project = get_project key
      content = value[:content]
      dataset = nil
      content.each do |subslug|
        prj = get_project subslug
        dts = select_observations(project: prj, observed: (... LAST_TIME), **@opts)
        dts.update!
        unless dataset
          dataset = dts
        else
          dataset += dts
        end
      end
      @neighbors[project] = { dataset: dataset, species: (dataset % :species), users: (dataset % :user).count }
    end
    ekb = get_project "bioraznoobrazie-ekaterinburga"
    dataset = select_observations(project: ekb, observed: (... LAST_TIME), **@opts)
    @neighbors[ekb] = { dataset: dataset, species: (dataset % :species), users: (dataset % :user).count }
  end

end

class SpecialReport < BaseReport
end

class SummaryReport < BaseReport
end

def make_district_reports slug
  report = DistrictReport::new slug
  report.write_history
  report.write_comparison
end

def make_area_reports slug
  report = AreaReport::new slug
  report.write_history
  report.write_comparison
end

def make_special_reports slug
  # project = get_project slug
  # dataset = select_observations project: project, observed: (... LAST_TIME)
  # make_history project, dataset, mode: :special
  # make_radiuses project, dataset
end

def make_summary_report slug
  # project = get_project slug
  # dataset = select_observations project: project, quality_grade: 'research', observed: (... LAST_TIME)
  # make_history project, dataset, mode: :summary
  # make_summary project, dataset
end
