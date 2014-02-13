require 'confstruct'

module BinaryRecord
  module Settings
    class Defaults < ::Confstruct::Configuration
      def initialize
        super
        self.embed_mechanism = :pascal_string
        self.store_type_as = :string
      end
    end

    def self.defaults
      puts 'defaults'
      Defaults.new
    end
  
    def self.config 
      @@config ||= self.defaults
  
      if block_given?
        yield @@config
      else
        puts 'getting config'
        puts @@config.inspect
        @@config
      end
    end
  
    def self.config=(value)
      puts 'assigning'
      @@config = value
    end
  end

  def self.config(&block)
    puts 'configing'
    Settings.config(&block)
  end

  def self.config=(value)
    Settings.config = value
  end

  # initialize defaults
  self.config
end
