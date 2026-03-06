# frozen_string_literal: true

require_relative 'districts'
require_relative 'table'

include INatGet::Data::DSL

LAST_YEAR = today.year - 1
LAST_TIME = finish year: LAST_YEAR

def make_history dataset, mode: nil
end

def make_comparison dataset, neighbors
end

def make_radiuses dataset
end

def make_summary dataset
end

def make_district_reports slug
  project = get_project slug
  dataset = select_observations project: project, quality_grade: 'research', observed: (... LAST_TIME)
  make_history dataset
  neighbors = DISTRICTS[slug][:neighbors]
  make_comparison dataset, neighbors
end

def make_aria_reports slug
  project = get_project slug
  dataset = select_observations project: project, quality_grade: 'research', observed: (... LAST_TIME)
  make_history dataset
  neighbors = { projects: ZONES.keys.reject { |k| k == slug }, places: [] }
  make_comparison dataset, neighbors
end

def make_special_reports slug
  project = get_project slug
  dataset = select_observations project: project, observed: (... LAST_TIME)
  make_history dataset, mode: :special
  make_radiuses dataset
end

def make_summary_report slug
  project = get_project slug
  dataset = select_observations project: project, quality_grade: 'research', observed: (... LAST_TIME)
  make_history dataset, mode: :summary
  make_summary dataset
end
