class Uint8Table < ActiveRecord::Base
  acts_as_serializable
  endian :big

  validates_binary :field, :uint8
end

