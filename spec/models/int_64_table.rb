class Int64Table < ActiveRecord::Base
  acts_as_serializable
  endian :big

  validates_binary :field, :int64
end
