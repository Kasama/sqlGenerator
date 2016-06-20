require 'yaml'
require 'erb'
require './overloads'
require './table'
require './config'
require './errors'
require './helpers'
require './parser'
require './types'

def erbfy(filename, erb_params)
	ERB.new(File.read(filename).gsub(/^\s+/, ''), nil, '><%').result binding
end

config = Config.new(ENV['file'])

tab = parse(config)

output_folder = 'out'
sql_name = 'schema.sql'
File.open("#{output_folder}/#{sql_name}", "w+") do |f|
	print "Creating file #{sql_name}..."
	f.write(erbfy('template.sql.erb', tab))
	puts "Done"
end

tab.each do |table_name, table|
	current_java = "#{capitalize(table_name)}.java"
	print "Creating file #{current_java}..."
	File.open("#{output_folder}/#{current_java}", "w+") do |f|
		params = {table: table, package: "br.usp.icmc.paralimpiadas"}
		f.write(erbfy('template.java.erb', params))
	end
	puts "Done"
end

