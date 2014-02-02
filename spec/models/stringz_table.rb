class StringzTable < ActiveRecord::Base
  acts_as_serializable
  endian :big

  validates_binary :field, :stringz
end
