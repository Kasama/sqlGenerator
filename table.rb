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
	attr_accessor :name, :rows, :PK, :FK, :check, :unique
	def initialize(name, rows = {}, pk = [], fk = [], check = [], unique = {})
		self.name = name
		self.rows = rows
		self.PK = a(pk)
		self.FK = a(fk)
		self.check = a(check)
		self.unique = unique
	end
end
