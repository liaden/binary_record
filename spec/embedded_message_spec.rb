require 'spec_helper'

describe "Embedded Messages" do
  describe "with static relationship" do
    let(:message) do
      EmbeddedMessageFixedType.create(:uint16_table => Uint16Table.create(:field => 5))
    end

    it "creates instance" do
      message.should be_an_instance_of(EmbeddedMessageFixedType)
    end

    it "creates associated record" do
      message.uint16_table.should be_an_instance_of(Uint16Table)
    end

    it "validates embedded message" do
      message.uint16_table.field = -1
      message.should_not be_valid
    end

    it "writes a binary string" do
      message.to_binary_s.should_not be_empty
    end

    it "parses from a binary string" do
      msg = EmbeddedMessageFixedType.read(message.to_binary_s)
      msg.should be_valid
      msg.uint16_table.field.should == 5
    end

    it "autosaves" do
      msg = EmbeddedMessageFixedType.new(:uint16_table => Uint16Table.new(:field => 3))

      expect {
        msg.save
      }.to change{Uint16Table.count}.by(1)

    end
  end

  describe "with polymorphic relationship" do
    let(:message) do
      EmbeddedMessagePolymorphicType.create(:my_message => Uint16Table.create(:field => 5))  
    end
    it "creates instance" do
      message.should be_an_instance_of(EmbeddedMessagePolymorphicType)
    end

    it "creates associated record" do
      message.my_message.should be_an_instance_of(Uint16Table)
    end
      
    it "stores assocation type" do
      message.my_message_type.should == Uint16Table.name
    end

    it "varies type for association" do
      message.my_message = Uint8Table.create(:field => 7)
      message.my_message.should be_an_instance_of(Uint8Table)
      message.my_message_type.should == Uint8Table.name
    end

    it "validates embedded message" do
      message.should be_valid
    end

    it "writes a binary string" do
      message.to_binary_s.should_not be_empty
    end

    it "parses from a binary string" do
      msg = EmbeddedPolymorphicType.read(message.to_binary_s)
      msg.should be_valid
      msg.my_message.field.should == 7
    end
  end
end
