class Int8Table < ActiveRecord::Base
  acts_as_serializable

  validates_binary :field, :int8
end
