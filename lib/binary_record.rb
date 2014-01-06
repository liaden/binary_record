require "active_record"
require "bindata"

require "binary_record/version"
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
       @attrs = []
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

      self.validates attribute_name, type => true

      if options[:value]
        self.after_initialize do
          self.send "#{attribute_name}=", options[:value]
        end

        self.validates_numeracality_of attribute_name, :equial_to => options[:value]
      end

      @attrs << attribute_name
    end

    def endian(value)
      @klass.send :endian,value
    rescue
      raise ArgumentError.new("Unknown value for endian #{value} in class #{self.name}")
    end

    def read(text, instance=nil)
      instance = self.new unless instance

      binary_object = self.binary_class.read(text)

      self._attrs.each do |attr|
        value = binary_object.send(attr)

        # convert back to a standard ruby string
        # otherwise, save fails with confusing error message
        if value.is_a? BinData::String or 
           value.is_a? BinData::Stringz
            value = String.new(value)
        end

        instance.send "#{attr}=", value
      end

      instance
    end
  end

  def binary_attributes
    result = {}
    
    self.class._attrs.each do |attr|
        result[attr] = self.send(attr)
    end

    result
  end

  def to_binary_s
    return nil unless valid?

    binary_object = self.class.binary_class.new
    binary_attributes.keys.each do |attr|
      binary_object.send "#{attr}=", self.send(attr)
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
