# frozen_string_literal: true

require 'fileutils'

require_relative 'lib/districts'

FileUtils.mkdir_p 'generated'

list = File.open 'generated.lst', 'w'

DISTRICTS.each do |key, _|
  File.open "generated/#{ key }.rb", 'w' do |file|
    file.puts '# frozen_string_literal: true'
    file.puts ''
    file.puts "require_relative '../lib/report'"
    file.puts ''
    file.puts "make_district_reports '#{ key }'"
  end
  list.puts "generated/#{ key }.rb"
end

ZONES.each do |key, _|
  File.open "generated/#{key}.rb", "w" do |file|
    file.puts "# frozen_string_literal: true"
    file.puts ''
    file.puts "require_relative '../lib/report'"
    file.puts ''
    file.puts "make_aria_reports '#{ key }'"
  end
  list.puts "generated/#{key}.rb"
end

SPECIALS.each do |key, _|
  File.open "generated/#{key}.rb", "w" do |file|
    file.puts "# frozen_string_literal: true"
    file.puts ''
    file.puts "require_relative '../lib/report'"
    file.puts ''
    file.puts "make_special_reports '#{ key }'"
  end
  list.puts "generated/#{key}.rb"
end

list.close
