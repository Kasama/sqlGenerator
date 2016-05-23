require 'yaml'
require 'erb'
require './overloads'
require './table'
require './config'
require './errors'
require './helpers'
require './parser'

config = Config.get('exercicio.yml.erb')

tab = parse(config)

puts ERB.new(File.read('template.sql.erb').gsub(/^\s+/, ''), nil, '><%').result binding
