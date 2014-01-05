class Int32Table < ActiveRecord::Base
  acts_as_serializable
  endian :big

  validates_binary :field, :int32
end
