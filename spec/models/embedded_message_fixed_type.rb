class EmbeddedMessageFixedType < ActiveRecord::Base
  acts_as_serializable
  endian :big

  embedded_message :uint16_table, :autosave => true
end

