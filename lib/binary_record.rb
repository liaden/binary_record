require "active_record"
require "bindata"

require "binary_record/version"
require "extensions/fixnum"
require "extensions/active_record"

Dir["validators/*"].each { |file| require file }

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

      if options[:value]
        self.after_initialize do
          self.send "#{attribute_name}=", options[:value]
        end

        self.validates_numeracality_of attribute_name, :equial_to => options[:value]
      end

      @attrs << attribute_name
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

end
