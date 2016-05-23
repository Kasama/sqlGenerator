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

def parse(config)
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
		if table.metadata.key?('check')
			tabb.check = table.metadata.check
		end
		if table.metadata.key?('FK')
			table.metadata.FK.each do |name, fk|
				fk.each do |local, foreign|
					tabb.FK << local
					tabb.rows[local].FK = foreign
				end
			end
		end
		tabb.unique = table.metadata.Unique if table.metadata.key?('Unique')
		tab[tabb.name] = tabb
	end
	tab
end
