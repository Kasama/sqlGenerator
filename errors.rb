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

