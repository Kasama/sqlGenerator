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

if ARGV.size != 3
	STDERR.puts "Usage: ${$0} <schema.yml.erb> <output_folder> <java_package>"
end

config = Config.new(ARGV[0])

tab = parse(config)

output_folder = ARGV[1]
sql_name = 'schema.sql'
print "Creating file #{sql_name}..."
File.open("#{output_folder}/#{sql_name}", "w+") do |f|
	f.write(erbfy('template.sql.erb', tab))
end
puts "Done"

tab.each do |table_name, table|
	current_java = "#{capitalize(table_name)}.java"
	print "Creating file #{current_java}..."
	File.open("#{output_folder}/#{current_java}", "w+") do |f|
		params = {table: table, package: ARGV[2]}
		f.write(erbfy('template.java.erb', params))
	end
	puts "Done"
end

