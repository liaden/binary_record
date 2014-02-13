module BinaryRecord
  class Attribute
    def initialize(attribute_name)
      @attribute_name = attribute_name
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
      attribute = Attribute.new(attribute_name)
      
      attribute.instance_variable_set :@class_name, class_name
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

    def size_name
      "#{@attribute_name}_size"
    end

    def type_name
      "#{@attribute_name}_type"
    end

    def embedded_class_name(binary_object=nil)
      @class_name.to_s.singularize.camelize
    end

    def value_from(object)
      object.send(@attribute_name)
    end

    def assign(object, value, associated_attr = nil)
      object.send("#{associated_attr || @attribute_name}=", value) 
    end

    def parse_value(binary_object, database_object)
      if embedded?
        if polymorphic?
          klass_name = binary_object.send(type_name).camelize
        else
          klass_name = embedded_class_name
        end

        value = klass_name.constantize.read(value_from(binary_object))
      else
        value = value_from(binary_object)

        if value.is_a? ::BinData::String or
           value.is_a? ::BinData::Stringz
            value = String.new(value)
        end
      end

      assign(database_object, value)
    end

    def write_value(binary_object, database_object)
      if embedded?

        embedded_text = value_from(database_object).to_binary_s

        assign(binary_object, embedded_text)
        assign(binary_object, embedded_text.size, size_name)

        if polymorphic?
          assign(binary_object, database_object.send(type_name),
                 "#{@attribute_name}_type") 
        end
      else
        assign(binary_object, value_from(database_object))
      end
    end

    def parsing_class(binary_object)
      result = @determine_parser.call(binary_object)

      # if string, constantize it, otherwise function already returned class
      result.try(:constantize) || result
    end
  end
end
