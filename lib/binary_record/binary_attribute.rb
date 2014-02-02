module BinaryRecord
  class BinaryAttribute
    def initialize(attribute_name)
      @attribute_name = attribute_name
    end

    def self.polymorphic_embedded(attribute_name, options)
      attribute = BinaryAttribute.new(attribute_name)
      attribute.instance_variable_set :@polymorphic, true
      attribute
    end

    def self.default_polymorphic_lookup
      lambda do |binary_object, attribute_name|
        binary_object.send("#{attribute_name}_type")
      end
    end

    def self.embedded(attribute_name, options)
      class_name = options[:class_name] || attribute_name
      attribute = BinaryAttribute.new(attribute_name)
      
      attribute.instance_variable_set :@embedded, true
      attribute.instance_variable_set :@class_name, class_name

      attribute
    end

    def self.field(attribute_name)
      BinaryAttribute.new(attribute_name)
    end

    def embedded?
      @embedded || @polymorphic
    end

    def polymorphic?
      @polymorphic
    end

    def size_name
      "#{@attribute_name}_size"
    end

    def embedded_class_name
      if polymorphic?
      else
        @class_name.to_s.singularize.camelize
      end
    end

    def value_from(object)
      object.send(@attribute_name)
    end

    def assign(object, value, associated_attr = nil)
      object.send("#{associated_attr || @attribute_name}=", value) 
    end

    def parse_value(binary_object, database_object)
      if embedded?
        puts "embedded_class_name = #{embedded_class_name}"
        value = embedded_class_name.constantize.read(value_from(binary_object))
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
