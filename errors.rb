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

# Error Messages
E_TYPES = 'Missing "types" definition'
E_JAVA = 'Type %s has no "Java" definition'
E_SQL = 'Type %s has no "SQL" definition'
E_DATABASE = 'Missing "database" definition'
E_TABLES = 'Missing "tables" definition in "database"'
E_ROWS = 'Missing "rows" definition in table "%s"'
E_ROWS_EMPTY = '"rows" definition in table "%s" is empty'
E_ROW_TYPE = 'Type of "%s" in table "%s" is unknown'
E_PK = 'Missing "PK" definition in table "%s"'
E_INVALID_PK = 'Attribute "%s" is unknown in table "%s"'
E_INVALID_FK = 'Attribute "%s" is unknown in table "%s"'
E_INVALID_FOREIGN = 'Table "%s" is unknown'
E_UNIQUE = ''
E_NN = ''
E_DEFAULT = ''
E_METADATA = 'Missing "metadata" definition in table "%s"'
