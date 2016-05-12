require 'yaml'
require 'erb'

Mandatory_fields = %w(types SQL Java database tables rows metadata)

class Hash
	def respond_to?(symbol, include_private=true)
		return true if key?(symbol.to_s)
		super
	end
	def method_missing(method_name, *args)
		if respond_to? method_name
			self[method_name.to_s]
		else
			if Mandatory_fields.include? method_name.to_s
				raise MissingMandatoryError.new("Missing mandatory key #{method_name} on #{self.inspect}")
			else
				super unless respond_to? method_name
			end
		end
	end
end

class MissingMandatoryError < StandardError
	def initialize(msg="Missing mandatory key on YAML")
		super
	end
end

class NoPrimaryKeyError < StandardError
	def initialize(msg="Missing primary key on a table")
		super
	end
end

class NilClass
	def key?(*args)
		false
	end
	def method_missing(method_name, *args)
		if Mandatory_fields.include? method_name.to_s
			raise MissingMandatoryError.new("Missing mandatory key #{method_name}")
		else
			super
		end
	end
end

class Row
	attr_accessor :name, :PK, :FK, :NN, :type, :default
	def initialize(name, type, pk = false, fk = nil, nn = false, default = nil)
		self.name = name
		self.type = type
		self.PK = pk
		self.FK = fk
		self.NN = nn
		self.default = default
	end
end

class Table
	attr_accessor :name, :rows, :PK, :FK, :check
	def initialize(name, rows = {}, pk = [], fk = [], check = [])
		self.name = name
		self.rows = rows
		self.PK = a(pk)
		self.FK = a(fk)
		self.check = a(check)
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

def normalize_config(config)
	config.database.tables.each do |table_name, table|
		unless table.metadata.key?('PK')
			raise NoPrimaryKeyError.new "Missing primary key on table #{table_name}"
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
end

config = Config.get('test.yml.erb')
normalize_config(config)


types = config.types
db = config.database
tables = db.tables
tab = {}

tables.each do |table_name, table|
	tabb = Table.new(table_name)
	table.rows.each do |row_name, row_type|
		fk = nil
		nn = false
		pk = false
		default = nil
		if (table.metadata.key?('NN') and
				table.metadata.NN.include? row_name)
			nn = true
		end
		if table.metadata.key?('default')
			default = table.metadata.default[row_name]
		end

		if table.metadata.PK == row_name
			pk = true
			tabb.PK << row_name
		end

		tabb.rows[row_name] = Row.new(
			row_name, types[row_type],
			pk, fk, nn, default
		)
	end
	if table.metadata.key?('check')
		tabb.check = table.metadata.check
	end
	if table.metadata.key?('FK')
		table.metadata.FK.each do |local, foreign|
			tabb.FK << local
			tabb.rows[local].FK = foreign
		end
	end
	tab[tabb.name] = tabb
end
puts tab.inspect

puts ERB.new(File.read('template.sql.erb').gsub(/^\s+/, ''), nil, '><%').result
