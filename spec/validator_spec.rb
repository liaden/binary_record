require 'spec_helper'

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

  describe 'stringz' do
    it 'is valid without null terminator' do
      StringzTable.new(:field => "hello world").should be_valid
    end

    it 'is valid with null terminators at end of string' do
      StringzTable.new(:field => "hello world\x00\x00").should be_valid
    end

    it 'is invalid when null terminator is not at the end' do
      StringzTable.new(:field => "hello\x00world").should_not be_valid
    end

    describe 'specified regex' do
      let(:regex) { StringzValidator.null_char_with_trailing_char_regex }
      it "matches '\\0a'" do
        regex.match("\0a").should_not be_nil
      end

      it "matches '\\0\\n'" do
        regex.match("\0\n").should_not be_nil
      end

      it "does not match 'a\\0'" do
        regex.match("a\0").should be_nil
      end
    end
  end

  describe 'string' do
    it 'is valid witih null terminators' do
      StringTable.new(:field => "\x00Hello\x00World\x00").should be_valid
    end

    it 'is valid without null terminators' do
      StringTable.new(:field => "Hello world").should be_valid
    end
  end
end
