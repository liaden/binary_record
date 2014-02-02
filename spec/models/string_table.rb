class StringTable < ActiveRecord::Base
  acts_as_serializable
  endian :big

  validates_binary :field, :string
end
