class Uint32Table < ActiveRecord::Base
  acts_as_serializable
  endian :big

  validates_binary :field, :uint32
end

