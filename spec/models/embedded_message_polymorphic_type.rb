class EmbeddedMessagePolymorphicType < ActiveRecord::Base
  acts_as_serializable
  endian :big

  embeds_message :my_message, :polymorphic => lambda { |record| record.embedded_message_type }
end
