
shared_examples 'obeys min/max' do
  it 'minimum is valid' do
    table.create(:field => minimum)
  end

  it 'maximum is valid' do
    table.create(:field => maximum)
  end

  it 'maximum+1 is invalid' do
    table.new(:field => maximum+1).should_not be_valid
  end

  it 'minimum-1 is invalid' do
    table.new(:field => minimum-1).should_not be_valid
  end

  describe 'binary class' do
    # due to the fact that bindata does not let a field
    # exceed what it can write out, we shall test to make
    # sure we have the correct mins and maxes
    it 'writes out bad data for minimum-1' do
      table_class = table.binary_class

      instance = table_class.new(:field => minimum-1)
      instance.field.should == minimum
    end
    it 'writes out bad data for maximum+1' do
      table_class = table.binary_class

      instance = table_class.new(:field => maximum+1)
      instance.field.should == maximum
    end
  end
end

describe "validations" do
  context 'unsigned' do
    let(:minimum) { 0 }

    describe 'uint8' do
      let(:maximum) { 2**8-1 }
      let(:table) { Uint8Table }

      it_behaves_like 'obeys min/max'
    end

    describe 'uint16' do
      let(:maximum) { 2**16-1 }
      let(:table) { Uint16Table }

      it_behaves_like 'obeys min/max'
    end

    describe 'uint32' do
      let(:maximum) { 2**32-1 }
      let(:table) { Uint32Table }

      it_behaves_like 'obeys min/max'
    end

    describe 'uint64' do
      let(:maximum) { 2**64-1 }
      let(:table) { Uint64Table}

      it_behaves_like 'obeys min/max'
    end
  end

  describe 'int8' do
    let(:minimum) { -(2**7) }
    let(:maximum) { 2**7-1 }
    let(:table) { Int8Table }

    it_behaves_like 'obeys min/max'
  end

  describe 'int16' do
    let(:minimum) { -(2**15) }
    let(:maximum) { 2**15-1 }
    let(:table) { Int16Table }

    it_behaves_like 'obeys min/max'
  end

  describe 'int32' do
    let(:minimum) { -(2**31) }
    let(:maximum) { 2**31-1 }
    let(:table) { Int32Table }

    it_behaves_like 'obeys min/max'
  end

  describe 'int64' do
    let(:minimum) { -(2**63) }
    let(:maximum) { 2**63-1 }
    let(:table) { Int64Table }

    it_behaves_like 'obeys min/max'
  end
end
