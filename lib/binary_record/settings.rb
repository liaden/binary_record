require 'confstruct'

module BinaryRecord
  module Settings
    def self.defaults
      Confstruct::Configuration.new 
    end
  
    def self.config 
      @config ||= self.defaults
  
      if block_given?
        yield @config
      else
        @config
      end
    end
  
    def self.config=(value)
      @config = value
    end
  end

  def self.config(&block)
    Settings.config(&block)
  end

  def self.config=(value)
    Settings.config = value
  end

  # initialize defaults
  self.config
end
