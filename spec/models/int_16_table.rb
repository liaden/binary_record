class Int16Table < ActiveRecord::Base
  acts_as_serializable
  endian :big

  validates_binary :field, :int16
end
