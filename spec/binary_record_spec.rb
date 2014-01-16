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

        it "reads in what it wrote out" do
          klass = table.to_s.constantize
          
          original = klass.new(:field => field_value)
          parsed = klass.read(original.to_binary_s)
          parsed.field.should == original.field
        end
    end
    
    it 'throws exception if invalid' do
      expect {
          Int8Table.new(:field => 4096).to_binary_s!
      }.to raise_error
    end
  end

  it 'reads with supplied instance' do
    text = Int8Table.new(:field => 56).to_binary_s
    target = Int8Table.new
    Int8Table.read(text, target).object_id.should == target.object_id
  end

  it 'defines read on an instance' do
    text = Int8Table.new(:field => 22).to_binary_s
    Int8Table.read(text).field.should == 22
  end

  it 'throws error reading empty string' do
    expect {
        Int8Table.read('')
    }.to raise_error(EOFError)
  end

  it 'require presence of binary attribute' do
    Int8Table.new.should_not be_valid
  end

end
