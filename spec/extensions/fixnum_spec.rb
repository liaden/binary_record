require 'spec_helper'

describe Fixnum do
  describe 'to_s' do
    it 'handles negative numbers' do
      -1.to_hex.should == '-0x1'
    end

    it 'handles 0' do
      0.to_hex.should == '0x0'
    end

    it 'handles 1024' do
      1024.to_hex.should == '0x400'
    end
  end
end
