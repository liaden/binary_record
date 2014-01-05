class ActiveRecord::Base
  def self.acts_as_serializable
    include ::BinaryRecord
  end
end
