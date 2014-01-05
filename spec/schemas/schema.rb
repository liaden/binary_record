ActiveRecord::Schema.define(:version => 20140105165633) do
  create_table :empty_binary_records do
  end

  create_table :int8_tables do |t|
    t.integer :field
  end

  create_table :int16_tables do |t|
    t.integer :field
  end

  create_table :int32_tables do |t|
    t.integer :field
  end

  create_table :int64_tables do |t|
    t.integer :field
  end
  create_table :uint8_tables do |t|

    t.integer :field
  end

  create_table :uint16_tables do |t|
    t.integer :field
  end

  create_table :uint32_tables do |t|
    t.integer :field
  end

  create_table :uint64_tables do |t|
    t.integer :field, :limit => 8
  end
end

