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
				super
			end
		end
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
