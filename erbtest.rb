require 'erb'

@class_name = "Jesus"
@varType = "int"
@varName = "myInt"

puts ERB.new(File.read("template.java.erb")).result
