# frozen_string_literal: true

require 'fileutils'

FileUtils.mkdir_p 'output'

require_relative 'districts'
require_relative 'table'

include INatGet::Data::DSL

LAST_YEAR = today.year - 1
LAST_TIME = finish_time year: LAST_YEAR

def compact_history rows
  return if rows.size <= 10
  first_year = rows.first[:raw_year]
  while rows.size > 10
    first_row = rows.shift
    next_row = rows.first
    next_row[:year] = "<i class=\"glyphicon glyphicon-calendar\"></i>  #{ first_year }–#{ next_row[:raw_year] } годы"
    next_row[:count] += first_row[:count]
    next_row[:news] += first_row[:news]
    next_row[:species] = next_row[:news]
    count_select = next_row[:count_link]
    count_select.delete :year
    count_select[:d2] = finish_time(year: next_row[:raw_year]).xmlschema.gsub('+', '%2B')
    species_select = count_select.merge({ view: "species", hrank: "species", lrank: "species" })
    next_row[:count_link] = count_select
    next_row[:species_link] = species_select
  end
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

def signature
  "<hr>\n" +
  "<small>Отчет составлен посредством <a href=\"https://github.com/inat-get/inat-get\">iNatGet v#{ version }</a>. См. также tg-канал <a href=\"https://t.me/inat_sverdlobl\">«Биоразнообразие Свердловской области в TG»</a> и его чат.</small>\n"
end

def make_history project, dataset, mode: nil
  result = []
  result << "<i>Учитваются только наблюдения исследовательского уровня. В подсчете видов — только виды и гибриды — старшие таксоны игнорируются, младшие приводятся к видам. Из-за этого выборки по наблюдениям и видам могут различаться.</i>\n" if mode != :special
  result << '## История'
  result << ''
  # project = dataset.key
  years = dataset % :observed_year
  years.sort!
  years_rows = []
  last_ds = nil
  olds = nil
  news = nil
  years.each do |ds|
    incoming = ds % :species
    if olds
      news = incoming - olds
      olds += incoming
    else
      news = incoming
      olds = incoming
    end
    count_select = { project_id: project.id, year: ds.key }
    count_select.merge!({ quality_grade: 'research' }) if mode != :special
    species_select = count_select.merge({ view: 'species', hrank: 'species', lrank: 'species' })
    years_rows << ({
      raw_year: ds.key,
      year: "<i class=\"glyphicon glyphicon-calendar\"></i>  #{ ds.key } год",
      count: ds.count,
      species: incoming.count,
      news: news.count,
      count_link: count_select,
      species_link: species_select
    })
    last_ds = ds
  end
  if last_ds.key != LAST_YEAR
    years_rows << { year: "<i class=\"glyphicon glyphicon-calendar\"></i>  #{ LAST_YEAR } год", count: 0, species: 0, news: 0 }
    last_ds = Dataset::new LAST_YEAR, NOTHING, true
    news = nil
  end
  compact_history years_rows
  years_rows.last[:style] = 'font-size:110%;'
  summa = {
    line_no: '',
    count: dataset.count,
    species: (dataset % :species).count,
    style: 'font-weight:bold;'
  }
  years_rows << summa
  years_table = ReportTable::new do
    column :line_no, '#', width: '3em', align: 'right', auto: true
    column :year, 'Период'
    column :count, 'Наблюдения', width: '8em', align: 'right'
    column :species, 'Виды', width: '6em', align: 'right'
    column :news, 'Новинки', width: '6em', align: 'right'
  end
  years_table << years_rows
  result << years_table.render
  result << ''

  # TODO: if на mode == :special

  top_title = false
  if last_ds && last_ds.count > 0
    users_last = last_ds % :user
    users_last.filter! { |ds| (ds % :species).count >= 10 }
    if users_last.count > 0
      users_last.sort! { |ds| [ -(ds % :species).count, -ds.count ] }
      users_last_top = users_last.first(10)
      result << '## Лучшие наблюдатели'
      result << ''
      result << 'Топ-10 из набравших не менее 10 видов.'
      result << ''
      top_title = true
      result << '### За сезон'
      result << ''
      top_rows = users_last_top.map do |ds|
        user = ds.key
        count_select = { project_id: project.id, year: LAST_YEAR, user_id: user.id, quality_grade: 'research' }
        species_select = count_select.merge({ view: 'species', hrank: 'species', lrank: 'species' })
        {
          user: "<a title=\"#{ user.name }\" href=\"https://www.inaturalist.org/people/#{ user.id }\"><i class=\"glyphicon glyphicon-user\"></i></a> @#{ user.login }",
          species: (ds % :species).count,
          count: ds.count,
          species_link: species_select,
          count_link: count_select
        }
      end
      top_table = ReportTable::new do
        column :line_no, '#', width: '3em', align: 'right', auto: true
        column :user, 'Наблюдатель'
        column :count, "Наблюдения", width: "8em", align: "right"
        column :species, 'Виды', width: '6em', align: 'right'
      end
      top_table << top_rows
      result << top_table.render
      result << ''
    end

    newcomers = users_last.filter { |ds| ds.key.created.year == LAST_YEAR }
    if newcomers.count > 0
      newcomers.sort! { |ds| [ -(ds % :species).count, -ds.count ] }
      newcomers_top = newcomers.first(10)
      result << '### Новички'
      result << ''
      newcomers_rows = newcomers_top.map do |ds|
        user = ds.key
        count_select = { project_id: project.id, year: LAST_YEAR, user_id: user.id, quality_grade: "research" }
        species_select = count_select.merge({ view: "species", hrank: "species", lrank: "species" })
        {
          user: "<a title=\"#{user.name}\" href=\"https://www.inaturalist.org/people/#{user.id}\"><i class=\"glyphicon glyphicon-user\"></i></a> @#{user.login}",
          species: (ds % :species).count,
          count: ds.count,
          species_link: species_select,
          count_link: count_select,
        }
      end
      newcomers_table = ReportTable::new do
        column :line_no, "#", width: "3em", align: "right", auto: true
        column :user, "Наблюдатель"
        column :count, "Наблюдения", width: "8em", align: "right"
        column :species, "Виды", width: "6em", align: "right"
      end
      newcomers_table << newcomers_rows
      result << newcomers_table.render
      result << ""
    end
  end
  if dataset && dataset.count > 0
    users_total = dataset % :user
    users_total.filter! { |ds| (ds % :species).count >= 10 }
    if users_total.count > 0
      users_total.sort! { |ds| [ -(ds % :species).count, -ds.count ] }
      users_total_top = users_total.first(10)
      unless top_title
        result << '## Лучшие наблюдатели'
        result << ''
        result << 'Топ-10 из набравших не менее 10 видов.'
        result << ''
      end
      result << '### За все время'
      result << ''
      top_rows = users_total_top.map do |ds|
        user = ds.key
        count_select = { project_id: project.id, d2: LAST_TIME.xmlschema.gsub('+', '%2B'), user_id: user.id, quality_grade: "research" }
        species_select = count_select.merge({ view: "species", hrank: "species", lrank: "species" })
        {
          user: "<a title=\"#{ user.name }\" href=\"https://www.inaturalist.org/people/#{ user.id }\"><i class=\"glyphicon glyphicon-user\"></i></a> @#{ user.login }",
          species: (ds % :species).count,
          count: ds.count,
          species_link: species_select,
          count_link: count_select,
        }
      end
      top_table = ReportTable::new do
        column :line_no, "#", width: "3em", align: "right", auto: true
        column :user, "Наблюдатель"
        column :count, "Наблюдения", width: "8em", align: "right"
        column :species, "Виды", width: "6em", align: "right"
      end
      top_table << top_rows
      result << top_table.render
      result << ''
    end
  end
  #
  if news && news.count > 0
    news_users = {}
    result << '## Новинки'
    result << ''
    result << 'Таксоны, наблюдавшиеся в этом сезоне впервые.'
    result << ''
    news.sort!
    news_rows = news.map do |ds|
      taxon = ds.key
      by_user = ds % :user
      by_user.each do |uds|
        user = uds.key
        news_users[user] ||= { count: 0, species: 0 }
        news_users[user][:count] += uds.count
        news_users[user][:species] += 1
      end
      count_select = { taxon_id: taxon.id, project_id: project.id, year: LAST_YEAR, quality_grade: 'research' }
      users_select = count_select.merge({ view: 'observers' })
      {
        taxon: "#{ taxon_icon taxon } #{ taxon_name taxon }",
        taxon_link: "https://www.inaturalist.org/taxa/#{ taxon.id }",
        count: ds.count,
        users: by_user.count,
        count_link: count_select,
        users_link: users_select
      }
    end
    news_table = ReportTable::new do
      column :line_no, '#', width: '3em', align: 'right', auto: true
      column :taxon, 'Таксон'
      column :count, 'Наблюдения', width: '8em', align: 'right'
      column :users, 'Люди', width: '6em', align: 'right'
    end
    news_table << news_rows
    result << news_table.render
    result << ''

    result << '### Наблюдатели новинок'
    result << ''
    users_rows = news_users.map do |user, value|
      {
        user: "<a title=\"#{user.name}\" href=\"https://www.inaturalist.org/people/#{user.id}\"><i class=\"glyphicon glyphicon-user\"></i></a> @#{user.login}",
        count: value[:count],
        species: value[:species]
      }
    end
    users_rows.sort_by! { |r| [ -r[:species], -r[:count] ] }
    users_table = ReportTable::new do
      column :line_no, "#", width: "3em", align: "right", auto: true
      column :user, "Пользователь"
      column :count, "Наблюдения", width: "8em", align: "right"
      column :species, "Виды", width: "6em", align: "right"
    end
    users_table << users_rows
    result << users_table.render
    result << ""
  end
  result << signature
  #
  File.write "output/#{ project.slug } - history.md", result.join("\n")
end

def make_comparison project, dataset, neighbors
end

def make_radiuses project, dataset
end

def make_summary project, dataset
end

def make_district_reports slug
  project = get_project slug
  dataset = select_observations project: project, quality_grade: 'research', observed: (... LAST_TIME)
  make_history project, dataset
  neighbors = DISTRICTS[slug][:neighbors]
  make_comparison project, dataset, neighbors
end

def make_aria_reports slug
  project = get_project slug
  dataset = select_observations project: project, quality_grade: 'research', observed: (... LAST_TIME)
  make_history project, dataset
  neighbors = { projects: ZONES.keys.reject { |k| k == slug }, places: [] }
  make_comparison project, dataset, neighbors
end

def make_special_reports slug
  project = get_project slug
  dataset = select_observations project: project, observed: (... LAST_TIME)
  make_history project, dataset, mode: :special
  make_radiuses project, dataset
end

def make_summary_report slug
  project = get_project slug
  dataset = select_observations project: project, quality_grade: 'research', observed: (... LAST_TIME)
  make_history project, dataset, mode: :summary
  make_summary project, dataset
end
