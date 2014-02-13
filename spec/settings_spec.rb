require 'spec_helper'

describe BinaryRecord::Settings do
  describe 'Defaults' do
    let(:defaults) { BinaryRecord::Settings::Defaults.new }
    it 'creates with settings' do
      defaults.store_type_as.should_not be_nil
      defaults.embed_mechanism.should_not be_nil
    end
  end

  it 'stores the values' do
    BinaryRecord.config do |config|
      config.value = 5
    end
    BinaryRecord.config.value.should == 5
  end
end
