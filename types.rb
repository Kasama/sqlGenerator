module Types
	def [](key)
		unless self.key? key
			raise MissingMandatoryError, "'#{key}' is not a defined Type"
		end
		super
	end
end
