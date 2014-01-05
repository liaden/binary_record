require 'spec_helper'

describe BinaryRecord do
  describe "to_binary_s" do
    [[:Int8Table, 127],
     [:Uint8Table, 255],
     [:Uint16Table, 0], 
     [:Uint32Table, 0],
     [:Uint64Table, 0] ].each do |table, field_value|
        it "writes out #{table}" do
          table.to_s.constantize.new(:field => field_value).to_binary_s.should_not be_empty
        end
    end
  end
end
