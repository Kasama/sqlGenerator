require './errors'

class Config
	attr_accessor :config

	def initialize(filename)
		@config = YAML.load(ERB.new(File.read(filename)).result) || {}
		check_errors
	end

	def check_errors
		assert_types config
		assert_database config
	end

	private

	def assert(boolean, msg)
		return if boolean
		STDERR.puts "Fatal: #{msg}"
		exit(1)
	end

	def assert_types(config)
		# ASSERT types exist
		assert(config.key?('types'), E_TYPES)
		assert(!config.types.nil?, E_TYPES)
		## ASSERT each type has SQL and Java
		config.types.each do |name, real|
			assert(real.key?('Java'), E_JAVA % name)
			assert(real.key?('SQL'), E_SQL % name)
		end
	end

	def assert_database(config)
		# ASSERT database exist
		assert(config.key?('database'), E_DATABASE)
		## ASSERT tables exist
		assert(config.database.key?('tables'), E_TABLES)

		assert_tables config
	end

	def assert_tables(config)
		config.database.tables.each do |table_name, table|
			assert_rows table_name, table
			assert_metadata table_name, table
		end
	end

	def assert_rows(table_name, table)
		### ASSERT each table has rows
		assert(table.key?('rows'), E_ROWS % table_name)
		#### ASSERT rows have at least one attribute
		assert(table.rows.any?, E_ROWS_EMPTY % table_name)
		table.rows.each do |row_name, type|
			##### ASSERT each attribute has a valid type
			assert(config.types.key?(type), E_ROW_TYPE % [row_name, table_name])
		end
	end

	def assert_metadata(table_name, table)
		### ASSERT each table has metadata
		assert(table.key?('metadata'), E_METADATA % table_name)

		assert_PK table_name, table
		assert_FK table_name, table if table.metadata.key?('FK')
		assert_Unique table_name, table if table.metadata.key?('Unique')
		assert_NN table_name, table if table.metadata.key?('NN')
		assert_Default table_name, table if table.metadata.key?('Default')
	end

	def assert_PK(table_name, table)
		#### ASSERT metadata contains PK
		assert(table.metadata.key?('PK'), E_PK % table_name)
		#--- Normalize PK
		table.metadata['PK'] = a(table.metadata.PK)
		table.metadata.PK.each do |pk|
			##### ASSERT PK is valid attribute
			assert(table.rows.key?(pk), E_INVALID_PK % [pk, table_name])
		end
	end

	def assert_FK(table_name, table)
		table.metadata.FK.each do |local, foreign|
			##### If FK's exist, ASSERT valid attribute
			assert(table.rows.key?(local), E_INVALID_FK % [local, table])
			##### If FK's exist, ASSERT valid foreign table
			assert(config.database.tables.key?(foreign), E_INVALID_FOREIGN % foreign)
		end
	end

	def assert_Unique(table_name, table)
		#---- Normalize Unique
		unless table.metadata.Unique.kind_of? (Hash)
			table.metadata['Unique'] =
				{ '1' => table.metadata.Unique }
		end
		table.metadata.Unique.each do |key, value|
			table.metadata.Unique[key] = a(value)
		end
		##### If Unique exist, ASSERT valid attributes
		table.metadata.Unique.each do |_, values|
			values.each do |attr|
				assert(table.rows.key?(attr), E_UNIQUE % [attr, table_name])
			end
		end
	end

	def assert_NN(table_name, table)
		#---- Normalize NN
		table.metadata['NN'] = a(table.metadata.NN)
		table.metadata.NN.each do |attr|
			##### If NN exist, ASSERT valid attributes
			assert(table.rows.key?(attr), E_NN % [attr, table_name])
		end
	end

	def assert_Default(table_name, table)
		#---- Normalize Default
		#table.metadata['Default'] = a(table.metadata.Default)
		table.metadata.Default.each do |attr, value|
			##### If Default exist, ASSERT valid attribute
			assert(table.rows.key?(attr), E_DEFAULT % [attr, table_name])
		end
	end
end

