require "binary_record/version"
require "active_record"

Dir["validators/*"].each { |file| require file }

module BinaryRecord
end
