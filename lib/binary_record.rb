require "active_record"
require "bindata"

require "binary_record/version"
require "binary_record/settings"
require "binary_record/attribute"
require "binary_record/attribute_builder"

require "extensions/fixnum"
require "extensions/active_record"

Dir.chdir('lib') do
  Dir["validators/*.rb"].each { |file| require file }
end

module BinaryRecord
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.extend(PrivateClassMethods)
    
    klass.class_eval do
       @attrs = {}

       @klass = Class.new(::BinData::Record)
    end
  end

  module PrivateClassMethods
    def _attrs
      @attrs
    end
  end

  module ClassMethods
    def binary_class
      @klass
    end

    def validates_binary(attribute_name, type, options = {})
      builder = AttributeBuilder.new(@klass, self)
      attribute = builder.build(attribute_name, type, options)
      _attrs[attribute_name] = attribute
    end

    def endian(value)
      @klass.send :endian,value
    rescue
      raise ArgumentError.new("Unknown value for endian #{value} in class #{self.name}")
    end

    def embeds_message(attribute_name, options = {})
      builder = AttributeBuilder.new(@klass, self)
      attribute = builder.build_embedded(attribute_name, options)
      _attrs[attribute_name] = attribute
    end

    def read(text, instance=nil)
      instance = self.new unless instance

      binary_object = self.binary_class.new 
      binary_object.read(text) 

      self._attrs.each do |attribute_name, attribute|
        attribute.parse_value(binary_object, instance)
      end

      instance
    end
  end

  def binary_attributes
    result = {}
    
    self.class._attrs.keys.each do |attr|
        result[attr] = self.send(attr)
    end

    result
  end

  def to_binary_s
    return nil unless valid?

    binary_object = self.class.binary_class.new
    self.class._attrs.each do |key, attribute|
      attribute.write_value(binary_object, self)
    end

    binary_object.to_binary_s
  end

  def to_binary_s!
    raise "Cannot write binary on invalid record #{self.class}.\n#{self.errors.messages}" unless valid?

    to_binary_s
  end

  def read(text)
    self.class.read(text, self)
  end
end
