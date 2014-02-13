module BinaryRecord
  class AttributeBuilder
    def initialize(binary_class, database_class)
      @binary_class = binary_class
      @database_class = database_class
    end

    def build(attribute_name, type, options)
      @binary_class.send type, attribute_name, options

      @database_class.validates attribute_name, type => true, :presence => true

      attribute = Attribute.new(:name => attribute_name)

      if options[:value]
        @database_class.after_initialize do
          attribute.assign(@database_class, options[:value])
        end

        @database_class.validates_numeracality_of attribute_name, :equal_to => options[:value]
      end

      attribute
    end

    def build_embedded(attribute_name, options)

      @database_class.validates attribute_name, :presence => true
      @database_class.belongs_to attribute_name, options

      embedded_data = { :name => attribute_name,
        :embed_mechanism => embed_mechanism(options)
      }

      if Attribute.polymorphic? options
        embedded_data.merge!( :store_type_as => store_type_as(options))
        @binary_class.send :stringz, Attribute.attr_name(attribute_name, :type)
      else
        parsing_class = Attribute.classify(options[:class_name] || attribute_name)
        embedded_data.merge!(:parsing_class => parsing_class)
      end

      attribute = Attribute.new(embedded_data)

      attr_size_name = attribute.attr_name(:size)
      @binary_class.send :uint16, attr_size_name
      @binary_class.send :string, attribute_name, :read_length => attr_size_name.to_sym

      attribute
    end

  private
    def embed_mechanism(options)
      options[:embed_mechanism] || BinaryRecord.config.embed_mechanism 
    end

    def store_type_as(options)
      options[:store_type_as] || BinaryRecord.config.store_type_as
    end
  end
end
