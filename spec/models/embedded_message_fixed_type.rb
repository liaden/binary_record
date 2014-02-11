class EmbeddedMessageFixedType < ActiveRecord::Base
  acts_as_serializable
  endian :big

  embeds_message :uint16_table, :autosave => true
end

