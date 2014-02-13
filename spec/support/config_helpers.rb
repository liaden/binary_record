def apply_default_config
  before(:all) do
    @prev_config = BinaryRecord.config
    BinaryRecord.config = BinaryRecord::Settings.defaults
  end

  after(:all) do
    BinaryRecord.config = @prev_config
  end
end
