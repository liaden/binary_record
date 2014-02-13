module BinaryRecord
  class Attribute
    attr_reader :name 

    def initialize(attribute_name)
      @name = attribute_name
    end

    def self.embed_mechanism(options)
      options[:embed_mechanism] || BinaryRecord.config.embed_mechanism 
    end

    def self.polymorphic(attribute_name, options)
      
      attribute = Attribute.new(attribute_name)

      attribute.instance_variable_set :@embed_mechanism, embed_mechanism(options)
      attribute.instance_variable_set :@store_type_as,
        options[:store_type_as] || BinaryRecord.config.store_type_as

      attribute
    end

    def self.embedded(attribute_name, options)
      class_name = options[:class_name] || attribute_name
      klass = class_name.to_s.singularize.camelize.constantize

      attribute = Attribute.new(attribute_name)
      
      attribute.instance_variable_set :@parsing_class, klass
      attribute.instance_variable_set :@embed_mechanism, embed_mechanism(options)

      attribute
    end

    def self.field(attribute_name)
      Attribute.new(attribute_name)
    end

    def embedded?
      not @embed_mechanism.nil?
    end

    def polymorphic?
      not @store_type_as.nil?
    end

    def attr_name(type)
      "#{name}_#{type}"
    end

    def embedded_class_name(binary_object=nil)
      @class_name.to_s.singularize.camelize
    end

    def parsing_class(binary_object)
      if polymorphic?
        klass_name = binary_object.send(attr_name(:type)).camelize
        klass_name.constantize
      else
        @parsing_class
      end
    end

    def lookup(object, attribute=nil)
      attribute ||= name
      object.send(attribute)
    end

    def assign(object, value, associated_attr = nil)
      object.send("#{associated_attr || name}=", value) 
    end

    def parse_value(binary_object, database_object)
      if embedded?
        value = parsing_class(binary_object).read(lookup(binary_object))
      else
        value = lookup(binary_object)

        if value.is_a? ::BinData::String or
           value.is_a? ::BinData::Stringz
            value = String.new(value)
        end
      end

      assign(database_object, value)
    end

    def write_value(binary_object, database_object)
      if embedded?

        embedded_text = lookup(database_object).to_binary_s

        assign(binary_object, embedded_text)
        assign(binary_object, embedded_text.size, attr_name(:size))

        if polymorphic?
          attr_type_name = attr_name(:type)
          type_identifier = lookup(database_object, attr_type_name)
          assign(binary_object, type_identifier, attr_type_name)
        end
      else
        assign(binary_object, lookup(database_object))
      end
    end
  end
end
