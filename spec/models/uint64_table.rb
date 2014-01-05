class Uint64Table < ActiveRecord::Base
  acts_as_serializable
  endian :big

  validates_binary :field, :uint64
end

