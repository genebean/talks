# frozen_string_literal: true
source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(URI('https://pages.github.com/versions.json').open.read)

gem 'github-pages', versions['github-pages'], group: :jekyll_plugins
gem 'jekyll-paginate'
