=begin
fields = {
	rows: 'rows',
	metadata: 'metadata',
	pk:	'PK',
	fk: 'FK',
	nn: 'NN',
	unique: 'Unique',
	check: 'check',
	sql: 'SQL',
	java: 'Java'
}
=end
def perform_checks(config)
=begin
	begin config.types
	rescue
		raise	MissingMandatoryError, "missing mandatory key 'types'"
	end
=end
	unless config.types
		raise MissingMandatoryError, "missing mandatory key 'types'"
	end
	unless config.database
		raise	MissingMandatoryError, "missing mandatory key 'database'"
	end
	unless config.database.tables
		raise	MissingMandatoryError, "missing mandatory key 'tables' on 'database'"
	end
end

def parse(c)
	config = c.config
	perform_checks(config)
	types = config.types
	types.extend(Types)
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
			if (table.metadata.key?('NN') &&
					table.metadata.NN.include?(row_name))
				nn = true
			end
			if table.metadata.key?('default')
				default = table.metadata.default[row_name]
			end
			if table.metadata.PK.include? row_name
				pk = true
				tabb.PK << row_name
			end

			tabb.rows[row_name] = Row.new(
					row_name, types[row_type],
					pk, fk, nn, default
			)
		end
		if table.metadata.key?('Check')
			tabb.check = table.metadata.Check
		end
		if table.metadata.key?('FK')
			table.metadata.FK.each do |local, foreign|
				raise MissingMandatoryError, "#{local} is not an attribute of table #{tabb.name}" unless table.rows.key? local
				raise MissingMandatoryError, "foreign table #{foreign} does not exist" unless tab.key? foreign
				tabb.FK << local
				tabb.rows[local].FK = foreign
			end
		end
		tabb.unique = table.metadata.Unique if table.metadata.key?('Unique')
		tab[tabb.name] = tabb
	end
	tab
end
