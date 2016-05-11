require 'yaml'
require 'erb'

class Hash
	def respond_to?(symbol, include_private=true)
		return true if key?(symbol.to_s)
		super
	end
	def method_missing(method_name, *args)
		return super unless respond_to? method_name
		self[method_name.to_s]
	end
end

class Row
	attr_accessor :name, :PK, :FK, :NN, :type
	def initialize(name, type, pk = false, fk = nil, nn = false)
		self.name = name
		self.type = type
		self.PK = pk
		self.FK = fk
		self.NN = nn
	end
end

class Table
	attr_accessor :name, :rows
	def initialize(name, rows = {})
		self.name = name
		self.rows = rows
	end
end

class Config
	def self.get(filename)
		YAML.load(ERB.new(File.read(filename)).result)
	end
end

def a(possibly_array)
	if possibly_array.kind_of?(Array)
		possibly_array
	else
		[possibly_array]
	end
end

config = Config.get('test.yml.erb')
config.database.tables.each_value do |table|
	unless table.metadata.key?('PK')
		raise NoMethodError
	end
	if table.metadata.key?('NN')
		table.metadata['NN'] = a(table.metadata.NN) 
	end
	if table.metadata.key?('Unique')
		table.metadata.Unique.each do |key, value|
			table.metadata.Unique[key] = a(value)
		end
	end
end
#puts config.inspect

types = config.types
db = config.database
tables = db.tables
tab = []

tables.each do |table_name, table|
	tabb = Table.new(table_name)
	table.rows.each do |row_name, row_type|
		fk = nil
		nn = false
		if (table.metadata.key?('FK') and
				table.metadata.FK.from == row_name)
			fk = table.metadata.FK.to
		end
		if (table.metadata.key?('NN') and
				table.metadata.NN.include? row_name)
			nn = true
		end

		tabb.rows[row_name] = Row.new(
			row_name,
			types[row_type],
			(table.metadata.PK == row_name),
			fk,
			nn
		)
	end
	tab << tabb
end
puts tab.inspect
exit

tables.each do |table_name, table|
	puts "Table #{table_name}:"
	table.rows.each do |row_name, row_type|
		puts "row: #{row_name} type #{types[row_type].SQL}"
	end
	puts "#{table_name} PK: #{table.metadata.PK}"
	puts "FK: from #{table_name}.#{table.metadata.FK.from} to #{table.metadata.FK.to}.#{tables[table.metadata.FK.to].metadata.PK}" if table.metadata.key?('FK')

	puts "======================="
end
