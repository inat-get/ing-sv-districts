# frozen_string_literal: true

require_relative 'lib/districts'
require_relative 'lib/table'

require 'fileutils'
FileUtils.mkdir_p 'output'

def user_html(user)
  "<a title=\"#{user.name}\" href=\"https://www.inaturalist.org/people/#{user.id}\"><i class=\"glyphicon glyphicon-user\"></i></a> @#{user.login}"
end

def subject_html(subject)
  title, icon = if subject.is_a?(INatGet::Data::Model::Place)
      [subject.display_name || subject.name, '<i class="fa fa-globe"></i>']
    else
      [subject.title.gsub(" области", " области").gsub(" района", " района").gsub(" округа", " округа").gsub(" и ", " и "), '<i class="fa fa-briefcase"></i>']
    end
  url = "https://www.inaturalist.org/#{subject.class.endpoint}/#{subject.id}"
  "<a href=\"#{url}\">#{icon}  #{title}</a>"
end

SIGNATURE = <<~TXT
  <hr>
  <small>Отчет составлен посредством <a href=\"https://github.com/inat-get/inat-get\">🌿 iNatGet v#{version}</a>, конкретные скрипты отчетов размещены в <a href=\"https://github.com/inat-get/ing-sv-districts\">отдельном репозитории</a>.
TXT

year = today.year
month = today.month
if month == 1
  month = 12
  year -= 1
else
  month -= 1
end

month_names = {
  1 => 'январь',
  2 => 'февраль',
  3 => 'март',
  4 => 'апрель',
  5 => 'май',
  6 => 'июнь',
  7 => 'июль',
  8 => 'август',
  9 => 'сентябрь',
  10 => 'октябрь',
  11 => 'ноябрь',
  12 => 'декабрь'
}

month_text = "#{ month_names[month] } #{ year }"

umbrella = get_project 'bioraznoobrazie-rayonov-sverdlovskoy-oblasti'

DISTRICTS.each do |key, _|
  project = get_project key
  # $stderr.puts({KEY: key, PROJECT: project}.inspect)
  observations = select_observations project: project, created_year: year, created_month: month
  users = observations % :user
  users.filter! { it.key.created.year == year && it.key.created.month == month }
  next if users.count == 0
  rows = users.map do |ds|
    user = ds.key
    species = ds % :species
    {
      user: user_html(user),
      count: ds.count,
      species: species.count
    }
  end
  table = ReportTable::new do
    column :line_no, '#', width: '3em', align: 'right', auto: true
    column :user, 'Пользователь'
    column :count, 'Наблюдения', width: '8em', align: 'right'
    column :species, 'Виды', width: '6em', align: 'right'
  end
  table << rows
  result = []
  result << "За последнее время (#{ month_text }) проект пополнился новыми наблюдениями, в том числе от тех, кто недавно зарегистрировался на iNaturalist."
  result << ''
  result << 'Хотелось бы поприветствовать новичков и, возможно, как-то помочь в освоении платформы. Кроме того, хочу обратить внимание, что iNaturalist — не только площадка для выкладывания наблюдений и определения всякого живого, но и сообщество, здесь, в общем-то, приветствуются вопросы (конечно, с соблюдением норм вежливости и такта).'
  result << ''
  result << 'Итак, приветствуем:'
  result << ''
  result << table.render
  result << ''
  result << "Рекомендую присоединится как к данному проекту — «#{ subject_html(project) }», так и к зонтичному проекту, объединяющему районы нашей области — «#{ subject_html(umbrella) }»."
  result << ''
  result << 'Полезные материалы:'
  result << ''
  result << '+ [Подборка инструкций от проекта «Флора России»](https://www.inaturalist.org/posts/97837)'
  result << '  + [iNaturalist: как пользоваться](https://www.inaturalist.org/posts/50510)'
  result << '  + [Как снимать, что снимать: учимся у классиков](https://www.inaturalist.org/posts/37806)'
  result << ''
  result << 'Если есть вопросы, их можно задавать прямо здесь.'
  result << ''
  result << SIGNATURE

  File.write "output/#{ key } - newcomers.md", result.join("\n")
end
