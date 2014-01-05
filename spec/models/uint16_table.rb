class Uint16Table < ActiveRecord::Base
  acts_as_serializable
  endian :big

  validates_binary :field, :uint16
end
