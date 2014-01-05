ActiveRecord::Schema.define(:version => 20140105165633) do
  create_table :empty_binary_records do
  end

  create_table :int8_tables do |t|
    t.integer :field
  end
end

