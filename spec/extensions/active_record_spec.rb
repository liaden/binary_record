require 'spec_helper'

describe "Active Record Extensions" do
  let(:test_class) { EmptyBinaryRecord }

  it 'acts as serializable' do
    test_class.should_not be_nil
  end

  it 'constructs an instance' do
    test_class.new.should_not be_nil
  end

  it 'writes an empty binary string' do
    test_class.new.to_binary_s.should be_empty
  end

  it 'writes out data' do
    puts Int8Table.new(:field => '2').to_binary_s.inspect

    Int8Table.new(:field => '2').to_binary_s.should == "\x02"
  end
end

