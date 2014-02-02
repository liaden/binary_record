require "active_record"
require "bindata"

require "binary_record/version"
require "binary_record/binary_attribute"
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
      @klass.send type, attribute_name, options

      self.validates attribute_name, type => true, :presence => true

      attribute = BinaryAttribute.field(attribute_name)
      @attrs[attribute_name] = attribute

      if options[:value]
        self.after_initialize do
          attribute.assign(self, options[:value])
        end

        self.validates_numeracality_of attribute_name, :equial_to => options[:value]
      end
    end

    def endian(value)
      @klass.send :endian,value
    rescue
      raise ArgumentError.new("Unknown value for endian #{value} in class #{self.name}")
    end

    def embedded_message(message_attribute, options = {})
      validates message_attribute, :presence => true
      belongs_to message_attribute, options

      attribute = BinaryAttribute.embedded(message_attribute, options)
      _attrs[message_attribute] = attribute

      @klass.send :uint16, attribute.size_name
      @klass.send :string, message_attribute, :read_length => attribute.size_name.to_sym
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
