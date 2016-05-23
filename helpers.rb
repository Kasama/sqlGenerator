def find_fks(table)
	fks = {}
	fks.extend FK
	table.FK.each do |row|
		foreign = table.rows[row].FK
		fks.addFK foreign, row
	end
	fks
end

module FK
	def addFK(foreign, row)
		if self[foreign].kind_of?(Array)
			self[foreign] << row
		else
			self[foreign] = [row]
		end
	end
end

def a(possibly_array)
	if possibly_array.kind_of?(Array)
		possibly_array
	else
		[possibly_array]
	end
end
