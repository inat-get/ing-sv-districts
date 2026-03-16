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
  LAST_DATE_STR = "#{ LAST_YEAR }-12-31"

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
      next_row[:news_link] = nil
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
      [subject.title.gsub(' области', ' области').gsub(' района', ' района').gsub(' округа', ' округа').gsub(' и ', ' и '), '<i class="fa fa-briefcase"></i>']
    end
    url = "https://www.inaturalist.org/#{ subject.class.endpoint }/#{ subject.id }"
    "<a href=\"#{ url }\">#{ icon }  #{ title }</a>"
  end

  def epilogue
    umbrella = get_project 'bioraznoobrazie-rayonov-sverdlovskoy-oblasti'
    "<i>Присоединяйтесь к данному проекту — #{ subject_html @project }.\nИ обратите внимание на зонтичный — #{ subject_html umbrella }, а также соответствующие <a href=\"https://t.me/inat_sverdlobl\">канал и чат в Telegram</a>.</i>"
  end

  def make_history preamble: nil
    result = []
    result << '## История'
    result << ''
    if preamble
      result << preamble
      result << ''
    end
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
      news_select = if news.count > 0 && news.count <= 500
        species_select.merge({ taxon_ids: news.map { |ds| ds.key.id.to_s }.join(',') })
      else
        nil
      end
      {
        year: ds.key,
        period: "<i class=\"glyphicon glyphicon-calendar\"></i>  #{ ds.key } год",
        count: ds.count,
        species: species.count,
        news: news.count,
        count_link: count_select,
        species_link: species_select,
        news_link: news_select
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
          news_users[user] ||= { count: 0, species: 0, taxa: [] }
          news_users[user][:count] += uds.count
          news_users[user][:species] += 1
          news_users[user][:taxa] << taxon
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
        count_select = @opts.merge({ project_id: @project.id, year: LAST_YEAR, user_id: key.id, taxon_ids: value[:taxa].map(&:id).map(&:to_s).join(',') })
        species_select = count_select.merge({ view: 'species' })
        value.merge({ user: user_html(key), count_link: count_select, species_link: species_select })
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
      count_select = @opts.merge({ d2: LAST_DATE_STR })
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

  def make_unique preamble: nil
    result = []
    @species = @dataset % :species
    uniques = @species
    @neighbors.each do |_, value|
      uniques -= value[:species]
    end
    if uniques.count > 0
      result << '## «Уники»'
      result << ''
      if preamble
        result << preamble
      else
        result << 'Таксоны, наблюдавшиеся здесь, но не найденные ни у кого из соседей.'
      end
      result << ''
      uniques.sort!
      uniques_users = {}
      uniques_rows = uniques.map do |ds|
        taxon = ds.key
        users = ds % :user
        users.each do |uds|
          user = uds.key
          uniques_users[user] ||= { count: 0, species: 0, taxa: [] }
          uniques_users[user][:count] += uds.count
          uniques_users[user][:species] += 1
          uniques_users[user][:taxa] << taxon
        end
        count_select = @opts.merge({ project_id: @project.id, d2: LAST_DATE_STR, taxon_id: taxon.id })
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
        count_select = @opts.merge({ project_id: @project.id, d2: LAST_DATE_STR, user_id: key.id, taxon_ids: value[:taxa].map(&:id).map(&:to_s).join(',') })
        species_select = count_select.merge({ hrank: 'species', lrank: 'species', view: 'species' })
        value.merge({ user: user_html(key), count_link: count_select, species_link: species_select })
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
    # result << "DEBUG: #{ (@species&.count).inspect }"
    wanted = commons - @species
    if wanted.count > 0
      result << '## «Разыскиваются»'
      result << ''
      result << "Топ-50 (из #{ wanted.count }) таксонов, найденных не менее, чем у двух соседей, но пока не обнаруженных здесь."
      result << ''
      wanted_rows = wanted.map do |ds|
        taxon = ds.key
        users = ds % :user
        count_select = @opts.merge(neighbors_select).merge({ d2: LAST_DATE_STR, taxon_id: taxon.id })
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

class SpecialReport < DistrictReport

  def initialize slug
    super slug
    @opts = {}
  end

  def load_data
    @project = get_project @slug
    @dataset = select_observations(project: @project, observed: (... LAST_TIME))
  end

  HISTORY_PREAMBLE = <<~TXT
    <i>Учитываются все наблюдения, попавшие в проект, Но в подсчете видов — только виды и гибриды — старшие таксоны игнорируются, младшие приводятся к видам. Из-за этого выборки по наблюдениям и видам могут расходиться между собой.</i>
  TXT

  def load_neighbors
    @opts = { quality_grade: 'research' }
    @neighbors = {}
    DISTRICTS.each do |key, _|
      project = get_project key
      dataset = select_observations(project: project, observed: (... LAST_TIME), **@opts)
      species = dataset % :species
      @neighbors[project] = { dataset: dataset, species: species, users: 0 }
    end
    @full_dataset = @dataset
    @dataset = @dataset.where(**@opts)
  end

  UNIQUE_PREAMBLE = <<~TXT
    <i>А здесь рассматриваются только наблюдения исследовательского уровня.</i>
  TXT

  def epilogue
    umbrella = get_project "bioraznoobrazie-rayonov-sverdlovskoy-oblasti"
    "<i>Обратите также внимание на зонтичный проект — #{ subject_html umbrella } — и соответствующие <a href=\"https://t.me/inat_sverdlobl\">канал и чат в Telegram</a>.</i>"
  end

  def write_history
    load_data
    result = []
    result << "Напомню, данный проект — #{ subject_html @project } — предназначен для отслеживания наблюдений," +
              ' сделанных на территории Свердловской области, но не попадающих ни в один «нормальный» районный проект.' +
              ' Непопадание такое может происходить из-за объективных причин: наблюдение совсем рядом с муниципальными' +
              ' границами, или место наблюдения скрыто и прямоугольник скрытия попадает на такую границу; но зачастую' +
              ' это происходит от того, что указанная точность неоправданно велика, и было бы неплохо, если б автор наблюдения' +
              ' ее поправил...'
    result << ''
    result << make_history(preamble: HISTORY_PREAMBLE)
    result << ''
    load_neighbors
    result << make_unique(preamble: UNIQUE_PREAMBLE)
    result << ''
    result << epilogue
    result << ''
    result << SIGNATURE
    File.write "output/#{ @slug } - history.md", result.join("\n")
  end

  def make_radii
    result = []
    limits = [ [ 100_000, '😨 Больше 100 км' ], [ 10000, '😠 10–100 км' ], [ 1000, '🤔 1–10 км' ], [ 500, '😐 500 м – 1 км' ] ]
    previous = nil
    limits.each do |radius, title|
      dataset = @full_dataset.where(accuracy: (radius ... previous), obscured: false)
      users = dataset % :user
      next if users.count == 0
      users_rows = users.map do |ds|
        user = ds.key
        count_select = { project_id: @project.id, user_id: user.id, d2: LAST_DATE_STR, acc_above: radius, geoprivacy: 'open', taxon_geoprivacy: 'open' }
        count_select.merge!({ acc_below: previous }) if previous
        species_select = count_select.merge({ hrank: 'species', lrank: 'species', view: 'species' })
        species = ds % :species
        {
          user: user_html(user),
          count: ds.count,
          species: species.count,
          count_link: count_select,
          species_link: species_select
        }
      end
      users_rows.sort_by! { |r| [ -r[:count], -r[:species] ] }
      previous = radius
      result << "\#\# #{ title }"
      result << ''
      table = ReportTable::new do
        column :line_no, '#', width: '3em', align: 'right', auto: true
        column :user, 'Наблюдатель'
        column :count, 'Наблюдения', width: '8em', align: 'right'
        column :species, 'Виды', width: '6em', align: 'right'
      end
      table << users_rows
      result << table.render
      result << ''
    end
    result.join("\n")
  end

  def write_radii
    result = []
    result << "Напомню, данный проект — #{ subject_html @project } — предназначен для отслеживания наблюдений," +
              ' сделанных на территории Свердловской области, но не попадающих ни в один «нормальный» районный проект.' +
              ' Непопадание такое может происходить из-за объективных причин: наблюдение совсем рядом с муниципальными' +
              ' границами, или место наблюдения скрыто и прямоугольник скрытия попадает на такую границу; но зачастую' +
              ' это происходит от того, что указанная точность неоправданно велика, и было бы неплохо, если б автор наблюдения' +
              ' ее поправил...'
    result << ''
    result << 'Ниже представлены ссылки на наблюдения (по пользователям), с <em>открытыми</em> координатами и <em>очень</em> большими радиусами точности. <i>Учитываются все наблюдения, попавшие в проект.</i>'
    result << ''
    result << make_radii
    result << ''
    result << epilogue
    result << ''
    result << SIGNATURE
    File.write "output/#{ @slug } - radii.md", result.join("\n")
  end

end

class SummaryReport < DistrictReport

  def load_data
    @opts = { quality_grade: 'research' }
    @project = get_project @slug
    DISTRICTS.each do |key, _|
      project = get_project key
      dataset = select_observations(project: project, observed: (... LAST_TIME), **@opts)
      dataset.update!
      unless @dataset
        @dataset = dataset
      else
        @dataset += dataset
      end
    end
    SPECIALS.each do |key, _|
      project = get_project key
      dataset = select_observations(project: project, observed: (... LAST_TIME), **@opts)
      dataset.update!
      unless @dataset
        @dataset = dataset
      else
        @dataset += dataset
      end
    end
  end

  SUMMARY_PREAMLE = <<~TXT
    Подведены итоги #{ LAST_YEAR } года в дочерних районных проектах. Итоги финальные в том смысле, что еще раз подводить их не имеет смысла, хотя, конечно, еще могут быть добавлены наблюдения из архивов, но вряд ли сильно меняющие общую картину.

    Ниже сводные таблицы со ссылками на соответствующие проекты, в журналах которых можно увидеть историю по годам, новинки данного сезона и т.д.

    В таблицах ниже показано количество наблюдений / видов / новинок — только по #{ LAST_YEAR } году и только исследовательского уровня. Сортировка по числу видов, лучшие результаты по числу наблюдений и новинок выделены жирным. «Лидер» — наблюдатель, зафиксировавший больше всего видов же.
  TXT

  def epilogue
    "<i>Присоединяйтесь к проекту — #{ subject_html @project } и дочерним, а также обратите внимание на <a href=\"https://t.me/inat_sverdlobl\">канал и чат в Telegram</a>.</i>"
  end

  def make_areas
    areas = {}
    ZONES.each do |key, value|
      project = get_project key
      dataset = nil
      value[:content].each do |slug|
        prj = get_project slug
        dts = select_observations(project: prj, observed: (... LAST_TIME), **@opts)
        dts.update!
        unless dataset
          dataset = dts
        else
          dataset += dts
        end
      end
      areas[project] = dataset
    end
    e_prj = get_project 'bioraznoobrazie-ekaterinburga'
    e_dts = select_observations(project: e_prj, observed: (... LAST_TIME), **@opts)
    areas[e_prj] = e_dts
    m_prj = get_project 'mezhmunitsipalnoe-bioraznoobrazie-sverdlovskoy-oblasti'
    m_dts = select_observations(project: m_prj, observed: (... LAST_TIME), **@opts)
    areas[m_prj] = m_dts
    rows = []
    areas.each do |project, dataset|
      project_html = if project == m_prj
        subject_html project
      else
        "<b>#{ subject_html project }</b>"
      end
      fresh = dataset.where(observed_year: LAST_YEAR)
      old = dataset - fresh
      fresh_species = fresh % :species
      old_species = old % :species
      new_species = fresh_species - old_species
      count_select = if fresh.count > 0
        @opts.merge({ project_id: project.id, year: LAST_YEAR })
      else
        nil
      end
      species_select = if fresh_species.count > 0
        count_select.merge({ hrank: 'species', lrank: 'species', view: 'species' })
      else
        nil
      end
      news_select = if new_species.count > 0 && new_species.count <= 500
        species_select.merge({ taxon_ids: new_species.map { |ds| ds.key.id.to_s }.join(',') })
      else
        nil
      end
      users = fresh % :user
      user_species = users.map do |ds|
        user = ds.key
        species = ds % :species
        { user: user, species: species.count }
      end
      maximum = unless user_species.empty?
        user_species.map { |us| us[:species] }.max
      else
        0
      end
      leaders = unless project == m_prj || maximum == 0
        user_species.select { |us| us[:species] == maximum }.map { |us| us[:user] }
      else
        []
      end
      row = {
        slug: project.slug,
        project: project_html,
        count: fresh.count,
        species: fresh_species.count,
        news: new_species.count,
        leaders: leaders.map { |u| "​@#{u.login}" }.join(', '),
        count_link: count_select,
        species_link: species_select,
        news_link: news_select
      }
      # row[:style] = 'font-weight:bold;' unless project == m_prj
      rows << row
    end
    rows.sort_by! { |r| [ -r[:species], -r[:news], -r[:count] ] }
    max_count = rows.map { it[:count] }.max
    rows.each { |r| r[:count] = "<b>#{ r[:count] }</b>" if r[:count] == max_count }
    max_species = rows.map { it[:species] }.max
    rows.each { |r| r[:species] = "<b>#{ r[:species] }</b>" if r[:species] == max_species }
    max_news = rows.map { it[:news] }.max
    rows.each { |r| r[:news] = "<b>#{ r[:news] }</b>" if r[:news] == max_news }
    table = ReportTable::new do
      column :line_no, '#', width: '3em', align: 'right', auto: true
      column :project, 'Проект'
      column :count, 'Наблюдения', width: '8em', align: 'right'
      column :species, 'Виды', width: '6em', align: 'right'
      column :news, 'Новинки', width: '6em', align: 'right'
      column :leaders, 'Лидер', width: '10em'
    end
    table << rows
    @order = rows.map { it[:slug] } - [ 'mezhmunitsipalnoe-bioraznoobrazie-sverdlovskoy-oblasti', 'bioraznoobrazie-ekaterinburga']
    result = []
    result << '## Административные округа и Екатеринбург'
    result << ''
    result << 'И сюда же «межмуниципальные» наблюдения — надо же их куда-нибудь прислонить.'
    result << ''
    result << table.render
    result << ''
    result.join("\n")
  end

  def make_one_area slug
    result = []
    data = ZONES[slug]
    result << "\#\# #{ data[:short] }"
    result << ''
    rows = []
    data[:content].each do |s|
      project = get_project s
      dataset = select_observations(project: project, observed: (... LAST_TIME), **@opts)
      fresh = dataset.where(observed_year: LAST_YEAR)
      fresh_species = fresh % :species
      old_species = (dataset - fresh) % :species
      new_species = fresh_species - old_species
      users = fresh % :user
      user_species = users.map do |ds|
        user = ds.key
        species = ds % :species
        { user: user, species: species.count }
      end
      leaders = unless user_species.empty?
        maximum = user_species.map { it[:species] }.max
        maximum > 1 ? user_species.select { it[:species] == maximum }.map { it[:user] } : []
      else
        []
      end
      count_select = fresh.count > 0 ? @opts.merge({ project_id: project.id, year: LAST_YEAR }) : nil
      species_select = fresh_species.count > 0 ? count_select.merge({ hrank: 'species', lrank: 'species', view: 'species' }) : nil
      news_select = new_species.count > 0 && new_species.count <= 500 ? species_select.merge({ taxon_ids: new_species.map { it.key.id.to_s }.join(',') }) : nil
      row = {
        project: subject_html(project),
        count: fresh.count,
        species: fresh_species.count,
        news: new_species.count,
        leaders: leaders.map { "​@#{ it.login }" }.join(', '),
        count_link: count_select,
        species_link: species_select,
        news_link: news_select
      }
      rows << row
    end
    rows.sort_by! { |r| [ -r[:species], -r[:news], -r[:count] ] }
    max_count = rows.map { it[:count] }.max
    max_species = rows.map { it[:species] }.max
    max_news = rows.map { it[:news] }.max
    rows.each { |r| r[:count] = "<b>#{ r[:count] }</b>" if r[:count] == max_count }
    rows.each { |r| r[:species] = "<b>#{ r[:species] }</b>" if r[:species] == max_species }
    rows.each { |r| r[:news] = "<b>#{ r[:news] }</b>" if r[:news] == max_news }
    table = ReportTable::new do
      column :line_no, "#", width: "3em", align: "right", auto: true
      column :project, "Проект"
      column :count, "Наблюдения", width: "8em", align: "right"
      column :species, "Виды", width: "6em", align: "right"
      column :news, "Новинки", width: "6em", align: "right"
      column :leaders, "Лидер", width: "10em"
    end
    table << rows
    result << table.render
    result << ''
    result.join("\n")
  end

  def write_summary
    result = []
    result << SUMMARY_PREAMLE
    result << ''
    result << make_areas
    result << ''
    @order.each do |slug|
      result << make_one_area(slug)
      result << ''
    end
    result << ''
    result << epilogue
    result << ''
    result << SIGNATURE
    File.write "output/#{ @slug } - summary.md", result.join("\n")
  end

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
  report = SpecialReport::new slug
  report.write_history
  report.write_radii
end

def make_summary_report slug
  report = SummaryReport::new slug
  report.write_history
  report.write_summary
end
