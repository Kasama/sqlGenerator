require 'yaml'
require 'erb'
require './overloads'
require './table'
require './config'
require './errors'
require './helpers'
require './parser'
require './types'

config = Config.new(ENV['file'])

tab = parse(config)

puts ERB.new(File.read('template.sql.erb').gsub(/^\s+/, ''), nil, '><%').result binding
