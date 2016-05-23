class Config
	def self.get(filename)
		cfg = YAML.load(ERB.new(File.read(filename)).result)
		normalize_config(cfg)
		cfg
	end

	def self.normalize_config(config)
		config.database.tables.each do |table_name, table|
			unless table.metadata.key?('PK')
				raise NoPrimaryKeyError.new "Missing primary key on table #{table_name}"
			end
			table.metadata['PK'] = a(table.metadata.PK)
			if table.metadata.key?('NN')
				table.metadata['NN'] = a(table.metadata.NN)
			end
			if table.metadata.key?('Unique')
				unless table.metadata.Unique.kind_of? (Hash)
					table.metadata['Unique'] = { '1' => table.metadata.Unique }
				end
				table.metadata.Unique.each do |key, value|
					table.metadata.Unique[key] = a(value)
				end
			end
			if table.metadata.key?('FK')
				unless table.metadata.FK.first[1].kind_of? (Hash)
					table.metadata['FK'] = { '1' => table.metadata.FK }
				end
			end
		end
	end
end


